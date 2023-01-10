import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/firestore_controller.dart';
import '../models/dish_model.dart';
import 'home_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<DishModel>?> favorites;

  getFavorites() async {
    setState(() {
      favorites = Firestore.getFavorites();
    });
  }

  removeFavorite(String id) {
    Firestore.removeFavorite(id);
    getFavorites();
  }

  @override
  void initState() {
    getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favorites"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.list_alt_rounded),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.green[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/chef.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container()),
            ListTile(
              leading: const Icon(
                Icons.list_alt_rounded,
                size: 30,
              ),
              title: const Text(
                'View all dishes',
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                size: 30,
              ),
              title: const Text(
                'Sign out',
              ),
              onTap: () {
                Auth().signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: ((context) => const HomePage())),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<DishModel>?>(
          future: favorites,
          builder: (context, dishes) {
            return dishes.hasData
                ? ListView.builder(
                    itemCount: dishes.data!.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        title: Text(dishes.data![index].name),
                        trailing: IconButton(
                            icon: const Icon(
                              Icons.heart_broken,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              removeFavorite(dishes.data![index].id!);

                              getFavorites();
                            }),
                      );
                    }),
                  )
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
