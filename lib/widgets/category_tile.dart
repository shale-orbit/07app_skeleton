import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CategoryTile({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}