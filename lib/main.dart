import 'package:flutter/material.dart';
import 'package:flutterv2/posepage.dart';
import 'homepage.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The yoga guide',
      //home: HomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/pose': (context) => const PosePage(), // Don't pass poseId here
      },
    );
  }
}
