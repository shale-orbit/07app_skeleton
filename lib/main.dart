import 'package:flutter/material.dart';
import 'home_page.dart';
import 'book_list_page.dart';
import 'book_detail_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_skeleton',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/list': (_) => const BookListPage(),
        '/detail': (_) => const BookDetailPage(),
      },
    );
  }
}