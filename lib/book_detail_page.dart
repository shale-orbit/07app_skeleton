import 'package:flutter/material.dart';
import 'book.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 关键：在 build 里取参数，类型断言成 Book
    final args = ModalRoute.of(context)?.settings.arguments;
    final book = args is Book ? args : null;

    if (book == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('图书详情')),
        body: const Center(child: Text('没有收到图书参数')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('图书详情')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _row('编号', book.id),
          _row('书名', book.title),
          _row('分类', book.category),
          _row('作者', book.author),
          _row('评分', '${book.rating} ★'),
          _row('借阅次数', '${book.borrowCount} 次'),
          _row('入馆月份', book.month),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            // pop 不带第二个参数 = 返回 null
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('返回'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Text(label, style: const TextStyle(color: Colors.black54)),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
}