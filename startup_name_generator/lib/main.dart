import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Startup Name Generator'),
        ),
        body: new Center(child: new Text('Startup Name Generator')),
      ),
    );
  }
}
