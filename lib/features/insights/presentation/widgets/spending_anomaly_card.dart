import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import '../../domain/entities/spending_anomaly.dart';

class SpendingAnomalyCard extends ConsumerStatefulWidget {
  final SpendingAnomaly anomaly;

  const SpendingAnomalyCard({super.key, required this.anomaly});

  @override
  ConsumerState<SpendingAnomalyCard> createState() =>
      _SpendingAnomalyCardState();
}

class _SpendingAnomalyCardState extends ConsumerState<SpendingAnomalyCard> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = ref.watch(currencySymbolProvider);

    switch (widget.anomaly.status) {
      case 'ANALYZED':
        return _buildAnalyzedCard(currencySymbol);

      case 'INSUFFICIENT_DATA':
        return _buildInfoCard(
          icon: Icons.insights_outlined,
          title: 'Spending Insights',
          message: widget.anomaly.message,
        );

      case 'TOO_EARLY':
        return _buildInfoCard(
          icon: Icons.schedule_outlined,
          title: 'Spending Analysis',
          message: widget.anomaly.message,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAnalyzedCard(String currencySymbol) {
    final c = context.colors;
    final isAnomaly = widget.anomaly.isAnomaly ?? false;

    final average = widget.anomaly.mean ?? 0;
    final difference = widget.anomaly.currentSpending - average;

    final percentageAboveAverage = average > 0
        ? (difference / average) * 100
        : 0;

    final statusColor = isAnomaly
        ? const Color(0xFFEF4444)
        : const Color(0xFF16A34A);

    final statusIcon = isAnomaly
        ? Icons.warning_amber_rounded
        : Icons.check_circle_outline;

    final statusTitle = isAnomaly
        ? 'Unusual Spending Detected'
        : 'Spending Looks Normal';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(statusIcon, color: statusColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  statusTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Main message
          Text(
            widget.anomaly.message,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: c.textSecondary,
            ),
          ),

          // Explanation for anomaly
          if (isAnomaly && average > 0) ...[
            const SizedBox(height: 12),
            Text(
              'You spent ${percentageAboveAverage.toStringAsFixed(1)}% '
              'more than your usual spending '
              '($currencySymbol${difference.toStringAsFixed(0)} above average).',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: c.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 20),

          // User-friendly statistics
          Row(
            children: [
              Expanded(
                child: _buildStat(
                  label: 'Current',
                  value:
                      '$currencySymbol${widget.anomaly.currentSpending.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _buildStat(
                  label: 'Average',
                  value: average > 0
                      ? '$currencySymbol${average.toStringAsFixed(0)}'
                      : '--',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Analysis details toggle
          InkWell(
            onTap: () {
              setState(() {
                _showDetails = !_showDetails;
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 18,
                    color: c.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Analysis Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                  Icon(
                    _showDetails
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: c.chevron,
                  ),
                ],
              ),
            ),
          ),

          // Expandable technical details
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _showDetails
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _buildAnalysisDetails(currencySymbol),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisDetails(String currencySymbol) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistical Analysis',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: c.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          _buildDetailRow(
            'Historical Average',
            widget.anomaly.mean != null
                ? '$currencySymbol${widget.anomaly.mean!.toStringAsFixed(2)}'
                : '--',
          ),

          const SizedBox(height: 10),

          _buildDetailRow(
            'Standard Deviation',
            widget.anomaly.standardDeviation != null
                ? widget.anomaly.standardDeviation!.toStringAsFixed(2)
                : '--',
          ),

          const SizedBox(height: 10),

          _buildDetailRow(
            'Z-Score',
            widget.anomaly.zScore?.toStringAsFixed(2) ?? '--',
          ),

          const SizedBox(height: 10),

          _buildDetailRow('Detection Threshold', '> 2.00'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final c = context.colors;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: c.textSecondary),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStat({required String label, required String value}) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: c.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: c.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String message,
  }) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2D5BFF), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
