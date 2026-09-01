import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
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

  static const _months = [
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

  Map<String, List<TransactionItem>> _groupTransactions(List<Transaction> allTransactions) {
    final grouped = <String, List<TransactionItem>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Sort by date descending
    final sorted = List<Transaction>.from(allTransactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    for (final e in sorted) {
      final date = DateTime(e.date.year, e.date.month, e.date.day);
      String label;
      if (date == today) {
        label = 'TODAY';
      } else if (date == yesterday) {
        label = 'YESTERDAY';
      } else {
        label = '${_months[date.month - 1]} ${date.day}, ${date.year}';
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
    final transactionsAsync = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF0FB),
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
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
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 20),
              Expanded(
                child: transactionsAsync.when(
                  data: (transactions) {
                    if (transactions.isEmpty) {
                      return const Center(child: Text('No transactions found'));
                    }
                    final grouped = _groupTransactions(transactions);
                    return _buildTransactionList(grouped);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search transactions...',
              hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.black38),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
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
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.black45,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
      radius: 24,
      backgroundColor: item.color.withValues(alpha: 0.15),
      child: Icon(item.icon, color: item.color, size: 22),
    );
  }

  Widget _buildTitleAndMeta(TransactionItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 3),
        Text(
          '${item.time}  •  ${item.category}',
          style: const TextStyle(fontSize: 12, color: Colors.black45),
        ),
      ],
    );
  }

  Widget _buildAmount(TransactionItem item) {
    final code = ref.watch(currencyProvider);
    return Text(
      CurrencyUtil.signed(item.amount, code),
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: item.isIncome ? Colors.green : Colors.red,
      ),
    );
  }
}
