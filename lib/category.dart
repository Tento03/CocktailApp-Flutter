import 'dart:async';
import 'dart:convert';

import 'package:cocktailapp/model/cocktail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  List<Drinks> drinks = [];
  bool isLoading = true;
  bool isSearching = false;
  final searchController = TextEditingController();
  List<String> categories = [
    'Cocktail',
    'Ordinary Drink',
    'Punch / Party Drink',
    'Shake',
    'Other / Unknown',
    'Cocoa',
    'Shot',
    'Coffee / Tea',
    'Homemade Liqueur',
    'Soft Drink',
  ];
  Timer? debounce;
  late TabController tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: categories.length, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        selectedIndex = tabController.index;
        setState(() {
          isLoading = true;
        });
        fetchData(categories[selectedIndex]);
      }
      fetchData(categories[selectedIndex]);
    });
  }

  Future<void> fetchData(var category) async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse(
      'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=$category',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        final List jsonFinal = jsonMap['drinks'];

        setState(() {
          drinks = jsonFinal.map((e) => Drinks.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          drinks = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data $e');
      drinks = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.startOffset,
          tabs: categories.map((e) => Tab(text: e)).toList(),
        ),
        title:
            isSearching
                ? TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                  onChanged: (value) {
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    Timer(Duration(milliseconds: 500), () {
                      setState(() {
                        isLoading = true;
                      });
                      fetchData(categories[selectedIndex]);
                    });
                  },
                )
                : Text('Category'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  fetchData(categories[selectedIndex]);
                }
              });
            },
            icon: isSearching ? Icon(Icons.close) : Icon(Icons.search),
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: drinks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        '${drinks[index].strDrinkThumb}',
                      ),
                    ),
                    title: Text('${drinks[index].strDrink}'),
                  );
                },
              ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
