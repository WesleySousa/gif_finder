import 'dart:convert';

import 'package:flutter/material.dart';
import './gif_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;
  int _limit = 19;

  bool isSearchTreading() {
    return _search == null || _search.isEmpty;
  }

  Future<Map> _getGifs() async {
    http.Response response;

    if (isSearchTreading()) {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=d5fAsBttcE6lg112pqtbJLq6VTpfdwGs&limit=20&rating=G');
    } else {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=d5fAsBttcE6lg112pqtbJLq6VTpfdwGs&q=$_search&limit=$_limit&offset=$_offset&rating=G&lang=pt');
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search here',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                color: Colors.white,
              ),
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      alignment: Alignment.center,
                      width: 200.0,
                      height: 200.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifGrid(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createGifGrid(BuildContext context, AsyncSnapshot snapshot) {
    int quantityItemsGrid = snapshot.data['data'].length;
    if (!isSearchTreading()) quantityItemsGrid += 1;

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: quantityItemsGrid,
      itemBuilder: (context, index) {
        if (isSearchTreading() || index < snapshot.data['data'].length) {
          return GestureDetector(
            child: Image.network(
              snapshot.data['data'][index]['images']['fixed_height']['url'],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPage(snapshot.data['data'][index]),
                ),
              );
            },
          );
        } else {
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: 300.0,
              height: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: 60.0,
                    color: Colors.white,
                  ),
                  Text(
                    'Load more...',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                _offset += _limit;
              });
            },
          );
        }
      },
    );
  }
}
