import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // a wordpair array
  final _biggerFont =
      const TextStyle(fontSize: 16.0); // to get bigger font size 18.0 here

  final color = Colors.black;

  // store favourited word pairings
  final _saved = new Set<WordPair>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _simpleValue;

  final String _simpleValue1 = 'Menu item value one';
  final String _simpleValue2 = 'Menu item value two';
  final String _simpleValue3 = 'Menu item value three';

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void showMenuSelection(String value) {
    if (<String>[_simpleValue1, _simpleValue2, _simpleValue3].contains(value))
      _simpleValue = value;
    showInSnackBar('You selected: $value');
  }

  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    // return new Text(wordPair.asPascalCase);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.notification_important),
              onPressed: _feedback),
          new IconButton(icon: new Icon(Icons.favorite), onPressed: _pushSaved),
          new PopupMenuButton<String>(
            icon: new Icon(Icons.arrow_drop_down),
            onSelected: showMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                      value: 'Item 1', child: const Text('Item 1')),
                  const PopupMenuItem<String>(
                      value: 'Item 2', child: const Text('Item 2')),
                  const PopupMenuItem<String>(
                      value: 'Item 1', child: const Text('Item 2'))
                ],
          )
        ],
      ),
      body: _buildSuggestions(),
      drawer: new Drawer(
          child: new Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: const Text('Sambhav Jain'),
            accountEmail: const Text('sambhavjain2612@gmail.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: const AssetImage('images/dp.jpg'),
            ),
          )
        ],
      )),
    );
  }

  // function to print suggested wordpair
  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemBuilder: (context, i) {
          // i is the iterator, begins from 0
          if (i.isOdd) return new Divider();

          final index = i ~/ 2; // divide i by 2 and return result

          // if you've reached word pairing end
          if (index >= _suggestions.length) {
            // generate 10 more word pairs
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    // check if given wordpair was already daved in the set
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(pair.asPascalCase, style: _biggerFont),
      trailing: new Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                  title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ));
            },
          );
          final divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Favourites'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  void _feedback() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
              appBar: new AppBar(
                title: new Text('About'),
              ),
              body: new Center(
                child: new Column(
                  children: <Widget>[
                    new Text('Hello, I am Sambhav Jain.'),
                    new Text('This is my first app.'),
                    new Expanded(child: new Text('XO'))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ));
        },
      ),
    );
  }
}
