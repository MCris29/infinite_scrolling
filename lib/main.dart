import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: RandomWords(),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {
  List<String> dogImages = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchFive();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //if we are at the bottom of the page
        fetchFive();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  fetch() async {
    var url = Uri.parse(
        "https://palabras-aleatorias-public-api.herokuapp.com/random");
    var client = http.Client();
    var request = await client.get(url);
    setState(() {
      dogImages.add(jsonDecode(request.body)["body"]["Word"].toString());
    });
  }

  fetchFive() {
    for (int i = 0; i < 40; i++) {
      fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Infinite Scrolling"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
          controller: _scrollController,
          itemCount: dogImages.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                constraints: BoxConstraints.tightFor(height: 50.0),
                child: ListTile(
                  title: Text(dogImages[index]),
                  trailing: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ));
          }),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}
