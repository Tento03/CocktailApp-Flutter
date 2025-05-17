import 'dart:async';
import 'dart:convert';

import 'package:cocktailapp/model/cocktail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Drinks> drinks = [];
  bool isLoading = true;
  final TextEditingController textEditingController = TextEditingController();
  bool isSearching = false;
  Timer? debounce;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final uri = Uri.parse(
      'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=${textEditingController.text}',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        final jsonFinal = jsonMap['drinks'];

        setState(() {
          if (jsonFinal != null) {
            drinks = List<Drinks>.from(
              jsonFinal.map((e) => Drinks.fromJson(e)),
            );
          } else {
            drinks = [];
          }
          isLoading = false;
        });
      } else {
        setState(() {
          drinks = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        drinks = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            isSearching
                ? TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Search Cocktail',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                  onChanged: (value) {
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    debounce = Timer(Duration(milliseconds: 500), () {
                      fetchData();
                    });
                  },
                )
                : Text('Search Page'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  textEditingController.clear();
                  fetchData();
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
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: drinks.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${drinks[index].strDrink}'),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              '${drinks[index].strDrinkThumb}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  @override
  void dispose() {
    debounce?.cancel();
    textEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
