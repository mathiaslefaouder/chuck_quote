import 'dart:convert';

import 'package:chuck_quote/model/categorie_model.dart';
import 'package:chuck_quote/model/quote_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuotePage extends StatefulWidget {
  final Categorie categorie;

  QuotePage({Key key, this.categorie}) : super(key: key);

  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  Quote quote;
  String catName;

  Future<Quote> _fetchQuote() async {
    String url = 'https://api.chucknorris.io/jokes/random';
    catName = this.widget.categorie.name;
    if (this.widget.categorie.name != "Give me a random quote !") {
      url = 'https://api.chucknorris.io/jokes/random?category=$catName';
    } else {
      catName = 'random';
    }

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      Map q = json.decode(response.body);

      quote = new Quote.fromJson(q);

      return quote;
    } else {
      throw Exception('Failed to load cat from API');
    }
  }

  Future _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchQuote();
  }

  void refreshQuote() {
    // reload
    setState(() {
      _future = _fetchQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quote from $catName',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Quote>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Quote data = quote;
                      return Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 90.0),
                              child: Text(
                                data.value,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.black),
                              )),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Column(
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: RaisedButton(
          child: Text(
            "New quote",
            style: TextStyle(fontSize: 20),
          ),
          color: Colors.blueAccent,
          textColor: Colors.white,
          padding: EdgeInsets.all(16.0),
          splashColor: Colors.grey,
          onPressed: () {
            refreshQuote();
          },
        ),
      ),
    );
  }
}
