import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(TVRemoteApp());
}

class TVRemoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter TV Remote App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TVRemoteHomePage(),
    );
  }
}
