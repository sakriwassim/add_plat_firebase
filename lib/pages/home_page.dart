import 'package:flutter/material.dart';
import 'package:mini_projet/pages/auth_page.dart';
import 'package:mini_projet/pages/dishes_page.dart';

import '../controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Auth().authStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const DishesPage();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}
