// ── Model ─────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

class NotificationItem {
  final String type;
  final String message;
  final String time;
  final IconData icon;
  final Color color;

  const NotificationItem({
    required this.type,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
  });
}