import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/features/home/domain/entities/notification.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<NotificationItem> _notifications = const [
    NotificationItem(
      type: 'Budget Alert',
      message: "You've reached 90% of your Food budget.",
      time: 'Just now',
      icon: Icons.warning_amber_rounded,
      color: Colors.red,
    ),
    NotificationItem(
      type: 'Reminder',
      message: "Don't forget to log your Rent payment today.",
      time: '2 hours ago',
      icon: Icons.calendar_today_outlined,
      color: Colors.orange,
    ),
    NotificationItem(
      type: 'Weekly Report',
      message: 'You saved \$50 more than last week!',
      time: 'Yesterday',
      icon: Icons.bar_chart_rounded,
      color: Colors.blue,
    ),
    NotificationItem(
      type: 'Goal Update',
      message: "You're \$20 away from your 'New Shoes' savings goal.",
      time: '2 days ago',
      icon: Icons.flag_rounded,
      color: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      appBar: _buildAppBar(c),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubtitle(c),
          Expanded(
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (_, i) => _buildNotificationCard(_notifications[i], c),
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(AppColorsPalette c) {
    return AppBar(
      backgroundColor: c.background,
      elevation: 0,
      leading: BackButton(color: c.textPrimary),
      title: Text(
        'Notifications',
        style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  // ── Subtitle ──────────────────────────────────────────────────────────
  Widget _buildSubtitle(AppColorsPalette c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(
        'Stay updated on your financial journey.',
        style: TextStyle(color: c.textSecondary, fontSize: 13),
      ),
    );
  }

  // ── Single notification card ──────────────────────────────────────────
  Widget _buildNotificationCard(NotificationItem item, AppColorsPalette c) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: item.color, width: 4)), // ← colored left bar
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconBox(item),
            const SizedBox(width: 12),
            Expanded(child: _buildContent(item, c)),
            _buildFadedIcon(item),
          ],
        ),
      ),
    );
  }

  // ── Colored icon circle ───────────────────────────────────────────────
  Widget _buildIconBox(NotificationItem item) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(item.icon, color: item.color, size: 20),
    );
  }

  // ── Type + message + time ─────────────────────────────────────────────
  Widget _buildContent(NotificationItem item, AppColorsPalette c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.type,
          style: TextStyle(
            color: item.color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.message,
          style: TextStyle(color: c.textPrimary, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 6),
        Text(
          item.time,
          style: TextStyle(color: c.textMuted, fontSize: 11),
        ),
      ],
    );
  }

  // ── Faded background icon (top right of card) ─────────────────────────
  Widget _buildFadedIcon(NotificationItem item) {
    return Icon(item.icon, color: item.color.withValues(alpha: 0.12), size: 36);
  }
} 