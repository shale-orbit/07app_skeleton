import 'package:flutter/material.dart';

import '../book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const BookTile({
    super.key,
    required this.book,
    required this.index,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: CircleAvatar(
        backgroundColor: Colors.primaries[index % Colors.primaries.length],
        child: Text('${index + 1}'),
      ),
      title: Text(book.title),
      subtitle: Text(
        '${book.category} · ${book.author} · 借阅 ${book.borrowCount} 次',
      ),
      trailing: Text(
        '${book.rating}★',
        style: const TextStyle(color: Colors.orange),
      ),
    );
  }
}
