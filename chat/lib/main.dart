import 'package:flutter/material.dart';

void main() {
  runApp(
    new ChatKaroBhai());
}

class ChatKaroBhai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Chat Karo Bhai",
      home: new ChatScreen()
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat Karo Bhai"),
      )
    );
  }
}