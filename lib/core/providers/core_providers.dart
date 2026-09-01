
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';

final storageServiceProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService(),
);
