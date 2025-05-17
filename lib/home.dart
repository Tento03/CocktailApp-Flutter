import 'dart:convert';

import 'package:cocktailapp/model/cocktail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Drinks> drinks = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var uri = Uri.parse(
      'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail',
    );
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      setState(() {
        final List jsonFinal = jsonMap['drinks'];
        drinks = jsonFinal.map((e) => Drinks.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        drinks = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'), backgroundColor: Colors.blue),
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
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              '${drinks[index].strDrinkThumb}',
                            ),
                          ),
                          title: Text('${drinks[index].strDrink}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
