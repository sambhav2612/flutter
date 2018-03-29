import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference().child('messages');

void main() {
  runApp(new ChatKaroBhai());
}

class ChatKaroBhai extends StatelessWidget {
  final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
  );

  final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.purple,
    accentColor: Colors.orangeAccent[400],
  );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Chat Karo Bhai",
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: new ChatScreen());
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
      analytics.logLogin();
    }
    if (await auth.currentUser() == null) {
      //new
      GoogleSignInAuthentication credentials = //new
          await googleSignIn.currentUser.authentication; //new
      await auth.signInWithGoogle(
        //new
        idToken: credentials.idToken, //new
        accessToken: credentials.accessToken, //new
      ); //new
    } //new
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    await _ensureLoggedIn();
    _sendMessage(text: text);
  }

  void _sendMessage({String text}) {
    reference.push().set({
      //new
      'text': text, //new
      'senderName': googleSignIn.currentUser.displayName, //new
      'senderPhotoUrl': googleSignIn.currentUser.photoUrl, //new
    }); //new
    analytics.logEvent(name: 'send_message');
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _textController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length >= 1;
                      });
                    },
                    onSubmitted: _handleSubmitted,
                    decoration: new InputDecoration.collapsed(
                        hintText: "Type your message"),
                  ),
                ),
                new Container(
                  child: new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: () => _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null),
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Chat Karo Bhai")),
        body: new Column(
          children: <Widget>[
            new Flexible(
              child: new FirebaseAnimatedList(
                query: reference, //new
                sort: (a, b) => b.key.compareTo(a.key), //new
                padding: new EdgeInsets.all(8.0), //new
                reverse: true, //new
                itemBuilder:
                    (_, DataSnapshot snapshot, Animation<double> animation) {
                  //new
                  return new ChatMessage(
                      //new
                      snapshot: snapshot, //new
                      animation: animation //new
                      ); //new
                }, //new
              ),
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            )
          ],
        ));
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.snapshot, this.animation}); // modified
  final DataSnapshot snapshot; // modified
  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
          new CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                  backgroundImage: new NetworkImage(
                      snapshot.value['senderPhotoUrl'])), //modified
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(snapshot.value['senderName'], //modified
                      style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(snapshot.value['text']), //modified
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
