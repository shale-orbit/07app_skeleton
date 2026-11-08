import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _categories = ['计算机技术', '经济管理', '科普百科', '文学小说', '艺术设计', '历史哲学'];

  String? _filter; // 从列表页 pop 回来的筛选条件

  Future<void> _openList(String category) async {
    final result = await Navigator.pushNamed(context, '/list', arguments: category);
    if (!mounted) return;
    if (result is String) {
      setState(() => _filter = result); // 回传值生效
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书分类'),
        // 副标题：显示回传值
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16, bottom: 6),
            child: Text(
              _filter == null ? '长按列表项可回传筛选条件' : '当前筛选：$_filter',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: [
          for (final c in _categories)
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _openList(c),
                child: Center(
                  child: Text(c,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}