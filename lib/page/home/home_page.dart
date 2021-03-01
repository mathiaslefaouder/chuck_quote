import 'dart:convert';

import 'package:chuck_quote/model/categorie_model.dart';
import 'package:chuck_quote/page/quote/quote_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textController = TextEditingController();

  List<Categorie> newCatList;

  List<dynamic> mainCatList;

  Future<List<Categorie>> _fetchCategorie() async {
    final cardsListAPIUrl = 'https://api.chucknorris.io/jokes/categories';
    final response = await http.get(cardsListAPIUrl);

    if (response.statusCode == 200) {
      List catList = json.decode(response.body);

      // Copy Main List into New List.
      newCatList =
          List.from(catList.map((cat) => new Categorie.fromJson(cat)).toList());

      mainCatList = catList.map((cat) => new Categorie.fromJson(cat)).toList();

      return newCatList;
    } else {
      throw Exception('Failed to load cat from API');
    }
  }

  onItemChanged(String value) {
    setState(() {
      newCatList = mainCatList
          .where((string) =>
              string.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchCategorie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Search Here...',
              ),
              onChanged: onItemChanged,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Categorie>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Categorie> data = newCatList;
                    return _cardsListView(data);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          )
        ],
      ),
    );
  }

  ListView _cardsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].name, data[index]);
        });
  }

  ListTile _tile(String name, Categorie categorie) => ListTile(
        title: Text(name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        // leading: Image.network(imageUrl),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuotePage(categorie: categorie)),
          );
        },
      );
}
