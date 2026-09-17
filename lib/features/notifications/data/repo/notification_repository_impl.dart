import 'dart:async';
import 'package:spendsmart/core/database/app_database.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repo/notification_repository.dart';
import '../datasources/notification_local_data_source.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final NotificationLocalDataSource _localDataSource;

  NotificationRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  NotificationItem _toDomain(LocalNotification row) {
    return NotificationItem(
      id: row.id,
      type: row.type,
      title: row.title,
      message: row.message,
      createdAt: row.createdAt,
      isRead: row.isRead,
    );
  }

  void _fetchAndCacheRemote(String userId) {
    _remoteDataSource.getNotifications().then((response) {
      if (response['statusCode'] == 200) {
        final payload = response['data'];
        final List<dynamic> data;
        if (payload is Map<String, dynamic> && payload['data'] is List) {
          data = payload['data'] as List<dynamic>;
        } else if (payload is List) {
          data = payload;
        } else {
          data = [];
        }

        final models = data
            .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
            .toList();

        _localDataSource.cacheNotifications(userId, models);
      }
    }).catchError((_) {});
  }

  @override
  Future<List<NotificationItem>> getNotifications() async {
    final userId = await _localDataSource.getUserId();

    // 1. Check local SQLite first
    if (userId != null) {
      final local = await _localDataSource.getNotifications(userId);
      if (local.isNotEmpty) {
        _fetchAndCacheRemote(userId);
        return local.map(_toDomain).toList();
      }
    }

    // 2. Fetch remote if local is empty
    try {
      final response = await _remoteDataSource.getNotifications();

      if (response['statusCode'] != 200) {
        return [];
      }

      final payload = response['data'];
      final List<dynamic> data;
      if (payload is Map<String, dynamic> && payload['data'] is List) {
        data = payload['data'] as List<dynamic>;
      } else if (payload is List) {
        data = payload;
      } else {
        data = [];
      }

      final models = data
          .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (userId != null) {
        await _localDataSource.cacheNotifications(userId, models);
      }

      return models;
    } catch (_) {
      if (userId != null) {
        final local = await _localDataSource.getNotifications(userId);
        if (local.isNotEmpty) {
          return local.map(_toDomain).toList();
        }
      }
      return [];
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    // 1. Update SQLite immediately via local data source
    await _localDataSource.markAsRead(notificationId);

    // 2. Update remote in background
    unawaited(() async {
      try {
        final response = await _remoteDataSource.markAsRead(notificationId);
        if (response['statusCode'] == 200) {
          await _localDataSource.markSynced(notificationId);
        }
      } catch (_) {}
    }());
  }

  @override
  Future<void> markAllAsRead() async {
    final userId = await _localDataSource.getUserId();

    // 1. Update SQLite immediately via local data source
    if (userId != null) {
      await _localDataSource.markAllAsRead(userId);
    }

    // 2. Update remote in background
    unawaited(() async {
      try {
        await _remoteDataSource.markAllAsRead();
      } catch (_) {}
    }());
  }
}