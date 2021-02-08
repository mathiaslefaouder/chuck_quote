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

  Future<Quote> _fetchQuote() async {
    String url = 'https://api.chucknorris.io/jokes/random';
    if (this.widget.categorie != null) {
      url =
          'https://api.chucknorris.io/jokes/random?category=${widget.categorie.name}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Quote from ${widget.categorie.name}'),
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
                        return Container(
                          child: Text(data.value),
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
        ));
  }
}
