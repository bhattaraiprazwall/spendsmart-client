# Changes Summary — Auth Integration with Riverpod Generator

## Overview

Integrated the register API into Flutter using a layered architecture with Riverpod Generator, GoRouter, FlutterSecureStorage, and a custom Failure class. 4 new files created, 7 existing files modified.

---

## New Files Created

### 1. `lib/core/errors/failure.dart`
**Purpose:** Custom error class for typed error handling.

```dart
class Failure {
  final String message;
  final int? statusCode;
  const Failure({required this.message, this.statusCode});
}
```
- Replaces raw `Map<String, dynamic>` returns and generic `catch (e)` blocks
- Used by `AuthService`, `AuthRepo`, and `AuthController`

---

### 2. `lib/core/services/secure_storage_service.dart`
**Purpose:** Wraps `FlutterSecureStorage` to persist auth session.

```dart
class SecureStorageService {
  Future<void> saveUser(UserModel user);   // writes user as JSON
  Future<UserModel?> getUser();            // reads stored user (null = no session)
  Future<void> clear();                    // deletes all stored data (logout)
}
```
- Token + user data stored in Android EncryptedSharedPreferences / iOS Keychain
- Called by `AuthController` after successful register

---

### 3. `lib/features/auth/presentation/providers/auth_controller.dart`
**Purpose:** Riverpod `@riverpod` notifier — the single source of auth state.

```dart
@riverpod
class AuthController extends _$AuthController {
  FutureOr<UserModel?> build();         // checks secure storage on app start
  Future<void> register(name, email, password);  // full register flow
  Future<void> logout();               // clears storage + Firebase session
}
```
**Register flow:**
1. Sets state to `AsyncLoading`
2. Calls `AuthRepo.register()` → `AuthService.register()` → `ApiService.post()`
3. On API success (201): signs in via `FirebaseAuth.instance.signInWithEmailAndPassword()`
4. Gets `idToken` from Firebase, adds it to `UserModel` via `copyWith(token: idToken)`
5. Saves `UserModel` (with token) to `FlutterSecureStorage`
6. Sets state to `AsyncData(userWithToken)`
7. On error: sets state to `AsyncError(errorMessage)`

---

### 4. `lib/routes/go_router_config.dart`
**Purpose:** Declarative routing with auth-aware redirects.

```dart
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  return GoRouter(
    redirect: (context, state) {
      if (authState.valueOrNull != null && onAuthPage) => '/home';
      if (!authState.valueOrNull && hasValue) => '/signup';
    },
    routes: [/signup, /login, /home],
  );
});
```
- **Authenticated user** on `/signup` or `/login` → redirects to `/home`
- **Unauthenticated user** on `/home` → redirects to `/signup`
- **Loading state** (checking storage) → no redirect (prevents flash)

---

## Modified Files

### 5. `pubspec.yaml`
**Before:**
```yaml
flutter_riverpod: ^3.3.1
riverpod_annotation: ^4.0.2
```
**After:** Added two dependencies:
```yaml
flutter_secure_storage: ^9.2.4
go_router: ^14.8.1
```

---

### 6. `lib/features/auth/data/models/user_model.dart`
**Before:** Empty file (0 lines)

**After:** Full model matching backend Prisma `User` schema:

| Field | Type | Source |
|-------|------|--------|
| `id` | `String` | Backend response |
| `firebaseUid` | `String` | Backend response |
| `name` | `String` | Backend response (field is `name`, not `fullname`) |
| `email` | `String` | Backend response |
| `role` | `String` | Backend response (default `'USER'`) |
| `token` | `String?` | From Firebase sign-in (not from register API) |

Methods: `fromJson`, `toJson`, `copyWith`

---

### 7. `lib/features/auth/data/services/auth_service.dart`
**Before:**
- Sent `fullname` as request body field
- Returned raw `Map<String, dynamic>` from `ApiService`
- No error handling

**After:**
- Sends `name` as request body field (matches backend)
- Returns `UserModel` on 201
- Throws `Failure` with extracted message on 400/500
- Parses Zod validation errors from `data["errors"]` array

---

### 8. `lib/features/auth/data/repositories/auth_repo.dart`
**Before:**
- Returned `Map<String, dynamic>` directly from service
- No error handling

**After:**
- Returns `UserModel` on success
- Re-throws `Failure` as-is
- Wraps unexpected `catch (e)` as `Failure`

---

### 9. `lib/features/auth/presentation/screens/signup_screen.dart`
**Before:**
- Plain `StatefulWidget`
- `_fullname` controller
- Static `PrimaryButton` with empty `onPressed: () {}`
- No API integration

**After:**
- `ConsumerStatefulWidget` (to access `ref`)
- `_name` controller (renamed to match backend)
- `ref.listen(authControllerProvider, ...)` shows SnackBar on errors
- `ref.watch(authControllerProvider)` enables loading state
- `PrimaryButton` disabled + shows "Loading..." during API call
- Password match validation (`_password.text != _confirmpassword.text`)
- Calls `ref.read(authControllerProvider.notifier).register()` on press
- Navigation is automatic via GoRouter redirect (no `Navigator.push`)

---

### 10. `lib/core/widgets/buttons/primary_button.dart`
**Before:**
```dart
final VoidCallback onPressed;  // non-nullable
```

**After:**
```dart
final VoidCallback? onPressed;  // nullable — allows disabling via null
```

Made `onPressed` nullable so the button can be disabled during API calls by passing `null`. Previously it was `VoidCallback` (non-nullable), which forced a no-op function to be passed even when the button should be disabled.

---

### 11. `lib/main.dart`
**Before:**
```dart
runApp(const MyApp());

class MyApp extends StatelessWidget {
  Widget build(context) => MaterialApp(home: SignupScreen());
}
```

**After:**
```dart
runApp(const ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  Widget build(context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(routerConfig: router);
  }
}
```

Key changes:
- `ProviderScope` wraps the app — makes Riverpod available everywhere
- `MyApp` is `ConsumerWidget` — can watch providers
- `MaterialApp.router` with GoRouter — auth-aware routing
- Removed direct imports of `SignupScreen`/`LoginScreen`/`HomeScreen` (now handled by GoRouter)

---

## Data Flow

```
User taps Sign Up
  → _handleRegister() called
    → password match check (local)
    → authControllerProvider.notifier.register(name, email, password)
      → state = AsyncLoading (button shows "Loading...", disabled)
      → AuthRepo.register()
        → AuthService.register()
          → ApiService.post('/api/auth/register', {name, email, password})
          ← 201 + User JSON
        ← UserModel
      ← UserModel
      → FirebaseAuth.instance.signInWithEmailAndPassword(email, password)
      → credential.user.getIdToken() → idToken
      → userWithToken = user.copyWith(token: idToken)
      → SecureStorageService.saveUser(userWithToken)
      → state = AsyncData(userWithToken)
      → GoRouter sees authenticated state, redirects to /home
    ← (on error) state = AsyncError(message)
      → ref.listen detects hasError, shows SnackBar
      → button re-enabled
```

## Dependencies Added

```yaml
flutter_secure_storage: ^9.2.4    # Encrypted token storage
go_router: ^14.8.1                # Auth-aware routing
```

## Commands Run

```bash
flutter pub get
dart run build_runner build
```

## Generated File

- `lib/features/auth/presentation/providers/auth_controller.g.dart` — auto-generated by Riverpod Generator

## Reverting

To revert all changes:
1. Remove these packages from `pubspec.yaml`:
   - `flutter_secure_storage: ^9.2.4`
   - `go_router: ^14.8.1`
2. Delete these new files:
   - `lib/core/errors/failure.dart`
   - `lib/core/services/secure_storage_service.dart`
   - `lib/features/auth/presentation/providers/auth_controller.dart`
   - `lib/features/auth/presentation/providers/auth_controller.g.dart`
   - `lib/routes/go_router_config.dart`
3. Restore these files from git:
   - `pubspec.yaml`
   - `lib/core/widgets/buttons/primary_button.dart`
   - `lib/features/auth/data/models/user_model.dart`
   - `lib/features/auth/data/services/auth_service.dart`
   - `lib/features/auth/data/repositories/auth_repo.dart`
   - `lib/features/auth/presentation/screens/signup_screen.dart`
   - `lib/features/auth/presentation/screens/login_screen.dart`
   - `lib/main.dart`
