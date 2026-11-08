import 'package:flutter/material.dart';
import 'book.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late final Future<List<Book>> _future = loadBooks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('图书列表')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: FutureBuilder<List<Book>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('加载失败：${snapshot.error}'));
              }
              // 先渲染 20 条模拟数据
              final books = snapshot.data!.take(20).toList();
              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, i) {
                  final b = books[i];
                  return ListTile(
                    onTap:()async{
                      final result = await Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: b, // 整个 Book 实例塞进 arguments，不是 id
                      );
                      debugPrint('详情页 pop 的返回值：$result'); // 步骤二应为 null
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.primaries[i % Colors.primaries.length],
                      child: Text('${i + 1}'),
                    ),
                    title: Text(b.title),
                    subtitle: Text('${b.category} · ${b.author} · 借阅 ${b.borrowCount} 次'),
                    trailing: Text('${b.rating}★',
                        style: const TextStyle(color: Colors.orange)),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}