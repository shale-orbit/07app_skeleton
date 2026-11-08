import 'dart:convert';
import 'package:flutter/services.dart';

class Book {
  final String id, title, category, author, month;
  final int rating, borrowCount;

  Book({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.rating,
    required this.borrowCount,
    required this.month,
  });

  factory Book.fromJson(Map<String, dynamic> j) => Book(
        id: j['id'] as String? ?? '',
        title: j['title'] as String? ?? '未命名',
        category: j['category'] as String? ?? '未分类',
        author: j['author'] as String? ?? '佚名',
        rating: (j['rating'] as num?)?.toInt() ?? 0,
        borrowCount: (j['borrowCount'] as num?)?.toInt() ?? 0,
        month: j['month'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'author': author,
        'rating': rating,
        'borrowCount': borrowCount,
        'month': month,
      };
}

/// 第4课是 File 读本地文件，Flutter 里改成读打包资源
Future<List<Book>> loadBooks() async {
  final raw = await rootBundle.loadString('assets/books.json');
  final list = jsonDecode(raw) as List;
  return list.map((e) => Book.fromJson(e as Map<String, dynamic>)).toList();
}