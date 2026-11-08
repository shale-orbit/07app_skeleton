import 'package:flutter/material.dart';
import 'widgets/info_row.dart';
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
          InfoRow('编号', book.id),
          InfoRow('书名', book.title),
          InfoRow('分类', book.category),
          InfoRow('作者', book.author),
          InfoRow('评分', '${book.rating} ★'),
          InfoRow('借阅次数', '${book.borrowCount} 次'),
          InfoRow('入馆月份', book.month),
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
}