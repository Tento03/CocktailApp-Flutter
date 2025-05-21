import 'package:cocktailapp/category.dart';
import 'package:cocktailapp/favorite.dart';
import 'package:cocktailapp/home.dart';
import 'package:cocktailapp/model/favorite.dart';
import 'package:cocktailapp/search.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main(List<String> args) async {
  await Hive.initFlutter;
  Hive.registerAdapter(FavoriteAdapter());
  await Hive.openBox<Favorite>('favBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BottomPage());
  }
}

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int selectedIndex = 0;
  List<Widget> pages = [
    HomePage(),
    SearchPage(),
    DefaultTabController(length: 6, child: CategoryPage()),
    FavoritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        initialActiveIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          TabItem(icon: Icon(Icons.home), title: 'Home'),
          TabItem(icon: Icon(Icons.search), title: 'Search'),
          TabItem(icon: Icon(Icons.category), title: 'Category'),
          TabItem(icon: Icon(Icons.favorite), title: 'Favorite'),
        ],
      ),
      body: pages[selectedIndex],
    );
  }
}
