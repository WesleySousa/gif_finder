import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {
  
  final Map _gifMap;

  GifPage(this._gifMap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(_gifMap['title']),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifMap['images']['fixed_height']['url']),
      ),
    );
  }
}
