import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF0FB),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAmountCard(),
            const SizedBox(height: 12),
            _buildDetailsCard(),
            const SizedBox(height: 12),
            _buildBudgetCard(),
            const SizedBox(height: 24),
            _buildEditButton(),
            const SizedBox(height: 8),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFEEF0FB),
      elevation: 0,
      leading: const BackButton(color: Colors.black),
      title: const Text(
        'Transaction Details',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  // ── Top amount card ───────────────────────────────────────────────────
  Widget _buildAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildCategoryIcon(),
          const SizedBox(height: 16),
          const Text(
            '\$42.50',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          const Text(
            'Lunch at Cafe',
            style: TextStyle(fontSize: 14, color: Colors.black45),
          ),
          const SizedBox(height: 12),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.restaurant, color: Colors.blue, size: 26),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.circle, color: Colors.blue, size: 8),
          SizedBox(width: 6),
          Text(
            'Completed',
            style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ── Details card ──────────────────────────────────────────────────────
  Widget _buildDetailsCard() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.category_outlined,       'Category',       'Food & Dining'),
            _buildDivider(),
            _buildDetailRow(Icons.calendar_today_outlined, 'Date',           'Oct 24, 2023'),
            _buildDivider(),
            _buildDetailRow(Icons.access_time_outlined,    'Time',           '1:15 PM'),
            _buildDivider(),
            _buildDetailRow(Icons.credit_card_outlined,    'Payment Method', 'Visa ending in 4242'),
            _buildDivider(),
            _buildNoteRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black45),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildNoteRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.notes_outlined, size: 18, color: Colors.black45),
              SizedBox(width: 10),
              Text('Note', style: TextStyle(color: Colors.black54, fontSize: 14)),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              'Business lunch with client regarding Q4 marketing strategy.',
              style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFF2F3F7));
  }

  // ── Budget card ───────────────────────────────────────────────────────
  Widget _buildBudgetCard() {
    const double spent = 320;
    const double total = 400;
    final double percent = spent / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Food & Dining Budget',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              Text('Oct 2023',
                  style: TextStyle(color: Colors.black45, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Spent: \$320.00',
                  style: TextStyle(color: Colors.black54, fontSize: 12)),
              Text('Total: \$400.00',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.centerRight,
            child: Text('80% Used',
                style: TextStyle(color: Colors.black45, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // ── Buttons ───────────────────────────────────────────────────────────
  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
        label: const Text('Edit Transaction',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
      label: const Text('Delete Option',
          style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }
}