import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'app_skeleton 案例\n\n'
          '首页网格 → 列表（分类 / 分页 / 长按筛选）→ 详情\n'
          '命名路由：/、/list、/detail、/about',
          style: TextStyle(height: 1.8),
        ),
      ),
    );
  }
}