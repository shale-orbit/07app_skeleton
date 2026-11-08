import 'package:flutter/material.dart';
import 'book.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late final Future<List<Book>> _future = loadBooks();

  /// 长按列表项：底部弹层 → 选择结果 pop 回首页
  Future<void> _showFilterSheet() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(dense: true, title: Text('筛选条件')),
            ListTile(
              leading: const Icon(Icons.filter_alt_outlined),
              title: const Text('仅看高借阅量（≥50 次）'),
              onTap: () => Navigator.pop(sheetContext, '仅看高借阅量'),
            ),
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text('取消'),
              onTap: () => Navigator.pop(sheetContext),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;
    Navigator.pop(context, choice); // 先关弹层，再把值 pop 回首页
  }

  @override
  Widget build(BuildContext context) {
    // 首页传进来的分类名；没传就是 null
    final category = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text(category == null ? '图书列表' : '图书列表 · $category'),
      ),
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

              final all = snapshot.data!;
              // 按分类过滤；没传分类就显示全部
              final matched = category == null
                  ? all
                  : all.where((b) => b.category == category).toList();
              final books = matched.take(20).toList();

              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, i) {
                  final b = books[i];
                  return ListTile(
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: b,
                      );
                      debugPrint('详情页 pop 的返回值：$result');
                    },
                    onLongPress: _showFilterSheet, // 长按弹层
                    leading: CircleAvatar(
                      backgroundColor:
                          Colors.primaries[i % Colors.primaries.length],
                      child: Text('${i + 1}'),
                    ),
                    title: Text(b.title),
                    subtitle: Text(
                        '${b.category} · ${b.author} · 借阅 ${b.borrowCount} 次'),
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