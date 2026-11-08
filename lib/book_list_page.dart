import 'package:flutter/material.dart';

import 'book.dart';
import 'list_args.dart';
import 'widgets/book_tile.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late final Future<List<Book>> _future = loadBooks();
  static const _pageSize = 20;
  int _visible = _pageSize; // 当前已加载条数
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
    // 首页传进来的参数：分类 + 是否只看高借阅量
    final args = ModalRoute.of(context)?.settings.arguments;
    final listArgs = args is ListArgs ? args : const ListArgs();
    final category = listArgs.category;
    final onlyHigh = listArgs.onlyHigh;

    return Scaffold(
      appBar: AppBar(
        title: Text(['图书列表', ?category, if (onlyHigh) '借阅≥50'].join(' · ')),
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

              final matched = snapshot.data!.where((b) {
                if (category != null && b.category != category) return false;
                if (onlyHigh && b.borrowCount < 50) return false;
                return true;
              }).toList();

              if (matched.isEmpty) {
                return const Center(child: Text('没有符合条件的图书'));
              }

                           final books = matched.take(_visible).toList();
              final hasMore = matched.length > _visible;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, i) {
                        final b = books[i];
                        return BookTile(
                          book: b,
                          index: i,
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: b,
                            );
                            debugPrint('详情页 pop 的返回值：$result');
                          },
                          onLongPress: _showFilterSheet,
                        );
                      },
                    ),
                  ),
                  if (hasMore)
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                setState(() => _visible += _pageSize),
                            child: Text(
                              '加载更多（还有 ${matched.length - _visible} 条）',
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        '已全部加载',
                        style:
                            TextStyle(color: Colors.black38, fontSize: 12),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
