import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/core/utils/currency_util.dart';
import 'package:spendsmart/features/transactions/domain/entities/transaction.dart';
import 'package:spendsmart/features/transactions/presentation/providers/transaction_provider.dart';

// ── Data model ────────────────────────────────────────────────────────────────
class TransactionItem {
  final String title;
  final String time;
  final String category;
  final double amount;
  final IconData icon;
  final Color color;
  final Transaction transaction;

  const TransactionItem({
    required this.title,
    required this.time,
    required this.category,
    required this.amount,
    required this.icon,
    required this.color,
    required this.transaction,
  });

  bool get isIncome => amount > 0;
}

// ── Screen ────────────────────────────────────────────────────────────────────
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _searchController = TextEditingController();

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  static const _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const _fullMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  void _shiftMonth(int delta) {
    HapticFeedback.lightImpact();
    setState(() {
      var month = _selectedMonth + delta;
      var year = _selectedYear;
      if (month < 1) {
        month = 12;
        year -= 1;
      } else if (month > 12) {
        month = 1;
        year += 1;
      }
      _selectedMonth = month;
      _selectedYear = year;
    });
  }

  void _resetToCurrentMonth() {
    HapticFeedback.lightImpact();
    final now = DateTime.now();
    setState(() {
      _selectedMonth = now.month;
      _selectedYear = now.year;
    });
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _selectedMonth == now.month && _selectedYear == now.year;
  }

  List<Transaction> _filterByMonthAndSearch(List<Transaction> allTransactions) {
    final query = _searchController.text.trim().toLowerCase();

    return allTransactions.where((t) {
      final matchesMonth =
          t.date.month == _selectedMonth && t.date.year == _selectedYear;
      if (!matchesMonth) return false;

      if (query.isNotEmpty) {
        final titleMatch = t.title.toLowerCase().contains(query);
        final categoryMatch = t.categoryName.toLowerCase().contains(query);
        return titleMatch || categoryMatch;
      }
      return true;
    }).toList();
  }

  Map<String, List<TransactionItem>> _groupTransactions(
      List<Transaction> transactions) {
    final grouped = <String, List<TransactionItem>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Sort by date descending
    final sorted = List<Transaction>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    for (final e in sorted) {
      final date = DateTime(e.date.year, e.date.month, e.date.day);
      String label;
      if (date == today) {
        label = 'TODAY';
      } else if (date == yesterday) {
        label = 'YESTERDAY';
      } else {
        label = '${_monthsShort[date.month - 1]} ${date.day}, ${date.year}';
      }
      grouped.putIfAbsent(label, () => []).add(_mapToTransactionItem(e));
    }
    return grouped;
  }

  TransactionItem _mapToTransactionItem(Transaction e) {
    final hour = e.date.hour;
    final minute = e.date.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final timeStr =
        '${h.toString().padLeft(2, ' ')}:${minute.toString().padLeft(2, '0')} $amPm';

    return TransactionItem(
      title: e.title,
      time: timeStr,
      category: e.categoryName,
      amount: e.isIncome ? e.amount : -e.amount,
      icon: _mapCategoryIcon(e.categoryIcon),
      color: _hexToColor(e.categoryColor),
      transaction: e,
    );
  }

  IconData _mapCategoryIcon(String iconName) {
    const iconMap = {
      "shopping_cart": Icons.shopping_cart,
      "directions_car": Icons.directions_car,
      "restaurant": Icons.restaurant,
      "home": Icons.home,
      "local_gas_station": Icons.local_gas_station,
      "flight": Icons.flight,
      "medical_services": Icons.medical_services,
      "checkroom": Icons.checkroom,
      "video_library": Icons.video_library,
      "more_horiz": Icons.more_horiz,
      "pets": Icons.pets,
      "fitness_center": Icons.fitness_center,
      "school": Icons.school,
      "desk": Icons.desk,
      "monitor": Icons.monitor,
      "keyboard": Icons.keyboard,
      "store": Icons.store,
      "work": Icons.work,
      "category": Icons.category,
    };
    return iconMap[iconName] ?? Icons.category;
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final transactionsAsync = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(context.tr('transaction_history')),
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(transactionProvider);
          return ref.read(transactionProvider.future);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildSearchBar(c),
              const SizedBox(height: 14),
              transactionsAsync.maybeWhen(
                data: (allTransactions) {
                  final monthTxs = allTransactions.where((t) {
                    return t.date.month == _selectedMonth &&
                        t.date.year == _selectedYear;
                  }).toList();

                  double monthIncome = 0;
                  double monthExpense = 0;
                  for (final t in monthTxs) {
                    if (t.isIncome) {
                      monthIncome += t.amount;
                    } else {
                      monthExpense += t.amount;
                    }
                  }

                  return _buildMonthSlider(c, monthIncome, monthExpense);
                },
                orElse: () => _buildMonthSlider(c, 0, 0),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: transactionsAsync.when(
                  data: (allTransactions) {
                    final monthTransactions =
                        _filterByMonthAndSearch(allTransactions);

                    if (monthTransactions.isEmpty) {
                      return _buildEmptyMonthState(c);
                    }
                    final grouped = _groupTransactions(monthTransactions);
                    return GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if ((details.primaryVelocity ?? 0) < -250) {
                          _shiftMonth(1); // Swipe left -> next month
                        } else if ((details.primaryVelocity ?? 0) > 250) {
                          _shiftMonth(-1); // Swipe right -> prev month
                        }
                      },
                      child: _buildTransactionList(grouped),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.receipt_long_outlined,
                              size: 48, color: c.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            context.tr('unable_to_load_dashboard'),
                            style: TextStyle(color: c.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                ref.invalidate(transactionProvider),
                            child: Text(context.tr('retry')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppColorsPalette c) {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: context.tr('search_transactions'),
        hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: c.textMuted, size: 20),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close, size: 18, color: c.textMuted),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              )
            : null,
        filled: true,
        fillColor: c.card,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.border.withValues(alpha: 0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.border.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2D5BFF), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildMonthSlider(
    AppColorsPalette c,
    double monthIncome,
    double monthExpense,
  ) {
    final currency = ref.watch(currencyProvider);
    final symbol = CurrencyUtil.symbolFor(currency);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Arrow Button
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 26),
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 38, minHeight: 38),
                splashRadius: 20,
                color: c.textPrimary,
                onPressed: () => _shiftMonth(-1),
                tooltip: 'Previous Month',
              ),

              // Month & Year Label
              Expanded(
                child: GestureDetector(
                  onTap: _isCurrentMonth ? null : _resetToCurrentMonth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_fullMonths[_selectedMonth - 1]} $_selectedYear',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: c.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (!_isCurrentMonth) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D5BFF)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D5BFF),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Right Arrow Button
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 26),
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 38, minHeight: 38),
                splashRadius: 20,
                color: c.textPrimary,
                onPressed: () => _shiftMonth(1),
                tooltip: 'Next Month',
              ),
            ],
          ),

          // Monthly inflow and outflow quick overview with clear labels
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: c.surface.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                // Income
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF00C853).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          size: 14,
                          color: Color(0xFF00C853),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.tr('income'),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: c.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '+$symbol${monthIncome.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF00C853),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  height: 26,
                  color: c.border.withValues(alpha: 0.5),
                ),

                // Expense
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFE53935).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          size: 14,
                          color: Color(0xFFE53935),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.tr('expense'),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: c.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '-$symbol${monthExpense.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE53935),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMonthState(AppColorsPalette c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: c.card,
                shape: BoxShape.circle,
                border: Border.all(color: c.border.withValues(alpha: 0.5)),
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                size: 36,
                color: c.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions in ${_fullMonths[_selectedMonth - 1]} $_selectedYear',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No matching results for "${_searchController.text}".'
                  : 'Swipe left/right or use arrows to view other months.',
              style: TextStyle(
                fontSize: 12.5,
                color: c.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(Map<String, List<TransactionItem>> grouped) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupLabel(entry.key),
            const SizedBox(height: 8),
            ...entry.value.map(_buildTransactionCard),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildGroupLabel(String label) {
    final displayLabel = label == 'TODAY'
        ? context.tr('today')
        : (label == 'YESTERDAY' ? context.tr('yesterday') : label);
    return Text(
      displayLabel,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: context.colors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTransactionCard(TransactionItem item) {
    return GestureDetector(
      onTap: () =>
          context.push(RoutePaths.transactionDetail, extra: item.transaction),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: context.colors.border.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            _buildIconCircle(item),
            const SizedBox(width: 12),
            Expanded(child: _buildTitleAndMeta(item)),
            _buildAmount(item),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCircle(TransactionItem item) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: item.color.withValues(alpha: 0.15),
      child: Icon(item.icon, color: item.color, size: 20),
    );
  }

  Widget _buildTitleAndMeta(TransactionItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${item.time}  •  ${item.category}',
          style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildAmount(TransactionItem item) {
    final code = ref.watch(currencyProvider);
    return Text(
      CurrencyUtil.signed(item.amount, code),
      style: TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        color: item.isIncome ? const Color(0xFF00C853) : const Color(0xFFE53935),
      ),
    );
  }
}
