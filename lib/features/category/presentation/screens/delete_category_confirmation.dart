import 'package:flutter/material.dart';

class DeleteCategoryConfirmation extends StatelessWidget {
  final String categoryName;
  final VoidCallback onDelete;

  const DeleteCategoryConfirmation({
    super.key,
    required this.categoryName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          const SizedBox(height: 16),
          _buildTitle(),
          const SizedBox(height: 16),
          _buildMessage(context),
          const SizedBox(height: 16),
          _buildCancelButton(context),
          const SizedBox(height: 16),
          _buildDeleteButton(context),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: const Icon(
        Icons.delete_outline_outlined,
        color: Colors.red,
        size: 32,
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Delete Category?',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      'Are you sure you want to delete "$categoryName"? This action cannot be undone. '
      'Previous transactions will not be deleted but will be moved to "Uncategorized".',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDDE0EF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onDelete();
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text('Delete', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
