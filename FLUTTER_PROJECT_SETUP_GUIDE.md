# Flutter Project Setup Guide - Step by Step

A comprehensive guide to creating and setting up a fully functional Flutter project with best practices.

---

## **Phase 1: Project Initialization**

### **Step 1.1: Create a New Flutter Project**

```bash
flutter create project_name
cd project_name
```

### **Step 1.2: Update `pubspec.yaml`**

- Add essential dependencies:
  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    # State Management
    provider: ^6.0.0
    # or
    bloc: ^8.0.0
    flutter_bloc: ^8.0.0

    # Routing
    go_router: ^10.0.0

    # HTTP & API
    http: ^1.1.0
    dio: ^5.0.0

    # Local Storage
    shared_preferences: ^2.0.0
    hive: ^2.0.0
    hive_flutter: ^1.1.0

    # Firebase (if needed)
    firebase_core: ^2.0.0
    cloud_firestore: ^4.0.0
    firebase_auth: ^4.0.0

    # UI/Design
    google_fonts: ^5.0.0
    flutter_screenutil: ^5.8.0

    # Utilities
    intl: ^0.18.0
    logger: ^2.0.0

  dev_dependencies:
    flutter_test:
      sdk: flutter
    flutter_lints: ^2.0.0
  ```

### **Step 1.3: Run `flutter pub get`**

```bash
flutter pub get
```

---

## **Phase 2: Project Folder Structure**

### **Step 2.1: Create Core Folder Structure**

```
lib/
├── main.dart
├── config/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   ├── text_styles.dart
│   │   └── dimensions.dart
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   └── string_constants.dart
│   └── firebase_options.dart
├── core/
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failure.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   └── interceptors.dart
│   ├── storage/
│   │   ├── local_storage.dart
│   │   └── preferences.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── extensions.dart
│   │   ├── logger.dart
│   │   └── helpers.dart
│   └── widgets/
│       ├── custom_appbar.dart
│       ├── custom_button.dart
│       ├── custom_textfield.dart
│       └── error_widget.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── signup_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── signup_page.dart
│   │       │   └── splash_page.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           └── signup_form.dart
│   │
│   ├── dashboard/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   └── [other_features]/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── routes/
    ├── app_router.dart
    ├── route_names.dart
    └── route_paths.dart
```

### **Step 2.2: Create Folder Explanations**

- **`config/`**: App-wide configurations (theme, constants, Firebase setup)
- **`core/`**: Reusable code (errors, networking, storage, utilities, widgets)
- **`features/`**: Feature-based structure using Clean Architecture
  - **`data/`**: Data sources, models, repository implementations
  - **`domain/`**: Entities, repositories (abstract), use cases
  - **`presentation/`**: UI layer (screens, widgets, state management)
- **`routes/`**: Centralized routing configuration

---

## **Phase 3: Theme Setup**

### **Step 3.1: Create `config/theme/colors.dart`**

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color primaryLight = Color(0xFF7C39EE);
  static const Color primaryDark = Color(0xFF3700B3);

  // Accent colors
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color accentLight = Color(0xFF66FFF9);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF757575);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyDark = Color(0xFF424242);

  // Status colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFB00020);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);
}
```

### **Step 3.2: Create `config/theme/text_styles.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  static final TextStyle headingLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final TextStyle headingMedium = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle headingSmall = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  static final TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  static final TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.greyDark,
  );

  static final TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}
```

### **Step 3.3: Create `config/theme/dimensions.dart`**

```dart
class AppDimensions {
  // Padding & Margins
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  // Border radius
  static const double borderRadiusSm = 8;
  static const double borderRadiusMd = 12;
  static const double borderRadiusLg = 16;

  // Icon sizes
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;

  // Button sizes
  static const double buttonHeight = 48;
  static const double buttonHeightSmall = 40;
}
```

### **Step 3.4: Create `config/theme/app_theme.dart`**

```dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'dimensions.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.white,

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.white,
      titleTextStyle: AppTextStyles.headingMedium,
      iconTheme: const IconThemeData(color: AppColors.black),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        ),
        textStyle: AppTextStyles.buttonText,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        borderSide: const BorderSide(color: AppColors.greyLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        borderSide: const BorderSide(color: AppColors.errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.md,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.headingLarge,
      displayMedium: AppTextStyles.headingMedium,
      displaySmall: AppTextStyles.headingSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.buttonText,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.greyDark,
    // ... similar configuration for dark theme
  );
}
```

---

## **Phase 4: Routing Setup**

### **Step 4.1: Create `routes/route_names.dart`**

```dart
class RouteNames {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String detail = '/detail';
}
```

### **Step 4.2: Create `routes/app_router.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import 'route_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const DashboardPage(),
        routes: [
          GoRoute(
            path: 'detail/:id',
            builder: (context, state) => DetailPage(id: state.pathParameters['id']!),
          ),
        ],
      ),
    ],
    // Handle 404s
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.location}'),
      ),
    ),
  );
}
```

---

## **Phase 5: State Management Setup (BLoC Pattern)**

### **Step 5.1: Create `features/auth/presentation/bloc/auth_event.dart`**

```dart
abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthSignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignupRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatusRequested extends AuthEvent {}
```

### **Step 5.2: Create `features/auth/presentation/bloc/auth_state.dart`**

```dart
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess({required this.message});
}

class AuthAuthenticated extends AuthState {
  final String userId;

  AuthAuthenticated({required this.userId});
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
```

### **Step 5.3: Create `features/auth/presentation/bloc/auth_bloc.dart`**

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;

  AuthBloc({required this.loginUsecase}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatusRequested>(_onCheckStatus);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await loginUsecase.execute(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(message: 'Login successful'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Check if user is already authenticated
    emit(AuthUnauthenticated());
  }
}
```

---

## **Phase 6: Core Utilities & Helpers**

### **Step 6.1: Create `core/utils/extensions.dart`**

```dart
import 'package:flutter/material.dart';

extension StringExtensions on String {
  bool isValidEmail() {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(this);
  }

  bool isValidPassword() {
    return length >= 8;
  }

  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  bool get isDarkMode => theme.brightness == Brightness.dark;
}

extension NumExtensions on num {
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
}
```

### **Step 6.2: Create `core/utils/validators.dart`**

```dart
class Validators {
  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Email is required';
    }
    if (!value!.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Password is required';
    }
    if (value!.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Name is required';
    }
    return null;
  }
}
```

### **Step 6.3: Create `core/utils/logger.dart`**

```dart
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger();

  static void info(String message) => _logger.i(message);

  static void debug(String message) => _logger.d(message);

  static void warning(String message) => _logger.w(message);

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
```

---

## **Phase 7: Core Widgets**

### **Step 7.1: Create `core/widgets/custom_button.dart`**

```dart
import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/dimensions.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppColors.white),
                ),
              )
            : Text(label, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}
```

---

## **Phase 8: API/Network Setup**

### **Step 8.1: Create `core/network/api_client.dart`**

```dart
import 'package:dio/dio.dart';
import '../../config/constants/api_constants.dart';
import '../utils/logger.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.debug('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.error('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw e.error ?? 'Something went wrong';
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw e.error ?? 'Something went wrong';
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw e.error ?? 'Something went wrong';
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw e.error ?? 'Something went wrong';
    }
  }
}
```

---

## **Phase 9: Local Storage**

### **Step 9.1: Create `core/storage/local_storage.dart`**

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    AppLogger.info('Local storage initialized');
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  static Future<bool> clear() async {
    return await _prefs.clear();
  }
}
```

---

## **Phase 10: Main Entry Point**

### **Step 10.1: Update `main.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/theme/app_theme.dart';
import 'core/storage/local_storage.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'routes/app_router.dart';
import 'core/network/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await LocalStorage.init();

  // Initialize API client
  final apiClient = ApiClient();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            loginUsecase: LoginUsecase(repository: AuthRepositoryImpl(apiClient: ApiClient())),
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
```

---

## **Phase 11: Dependency Injection (Optional - Recommended)**

### **Step 11.1: Create `core/di/service_locator.dart`**

```dart
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  getIt.registerSingleton<ApiClient>(ApiClient());
  await LocalStorage.init();

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(apiClient: getIt<ApiClient>()),
  );

  // Use Cases
  getIt.registerSingleton<LoginUsecase>(
    LoginUsecase(repository: getIt<AuthRepository>()),
  );

  // BLoCs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(loginUsecase: getIt<LoginUsecase>()),
  );
}
```

---

## **Phase 12: Testing Setup**

### **Step 12.1: Create Basic Unit Tests**

Create tests in `test/features/auth/presentation/bloc/auth_bloc_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:your_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:your_app/features/auth/domain/usecases/login_usecase.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

void main() {
  late AuthBloc authBloc;
  late MockLoginUsecase mockLoginUsecase;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    authBloc = AuthBloc(loginUsecase: mockLoginUsecase);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login is successful',
      build: () => authBloc,
      act: (bloc) => bloc.add(
        AuthLoginRequested(email: 'test@test.com', password: 'password123'),
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
    );
  });
}
```

---

## **Phase 13: Constants & Configuration**

### **Step 13.1: Create `config/constants/api_constants.dart`**

```dart
class ApiConstants {
  static const String baseUrl = 'https://your-api.com/api/v1';

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String dashboardEndpoint = '/dashboard';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
```

### **Step 13.2: Create `config/constants/app_constants.dart`**

```dart
class AppConstants {
  static const String appName = 'My App';
  static const String appVersion = '1.0.0';

  // Local storage keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';
}
```

---

## **Phase 14: Build & Run**

### **Step 14.1: Generate Code (if using build_runner)**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### **Step 14.2: Run the App**

```bash
flutter run
```

### **Step 14.3: Build APK/IPA**

```bash
# Android APK
flutter build apk

# iOS
flutter build ios
```

---

## **Phase 15: Code Organization Best Practices**

### **File Naming Conventions**

- Use snake_case for file names: `login_page.dart`, `auth_bloc.dart`
- Use PascalCase for class names: `LoginPage`, `AuthBloc`
- Use camelCase for variables and functions: `isLoading`, `fetchUser()`

### **Import Organization**

```dart
// Dart imports
import 'dart:async';

// Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:bloc/bloc.dart';

// Local imports
import '../../../config/theme/app_theme.dart';
```

### **Code Structure**

1. **Imports** at the top
2. **Class declaration**
3. **Properties** (static, final, then mutable)
4. **Constructors**
5. **Methods** (public first, then private)
6. **Static methods** at the end

---

## **Phase 16: Common Next Steps**

- ✅ Add Firebase authentication
- ✅ Implement local database (Hive/Sqflite)
- ✅ Add push notifications
- ✅ Implement analytics
- ✅ Add crash reporting (Firebase Crashlytics)
- ✅ Set up CI/CD pipeline (GitHub Actions, Fastlane)
- ✅ Implement offline support
- ✅ Add deep linking
- ✅ Implement app update checks
- ✅ Add localization (i18n)

---

## **Quick Reference Checklist**

- [ ] Create project structure
- [ ] Setup theme (colors, text styles, dimensions)
- [ ] Configure routing (go_router)
- [ ] Setup state management (BLoC)
- [ ] Create core utilities (validators, extensions, logger)
- [ ] Setup API client with interceptors
- [ ] Implement local storage
- [ ] Create reusable widgets
- [ ] Setup dependency injection
- [ ] Add unit tests
- [ ] Configure constants
- [ ] Update pubspec.yaml dependencies
- [ ] Test on physical device
- [ ] Build and release
