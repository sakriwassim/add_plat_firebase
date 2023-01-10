import 'package:flutter/material.dart';
import 'package:mini_projet/controllers/auth_controller.dart';
import 'package:mini_projet/controllers/firestore_controller.dart';
import 'package:mini_projet/models/dish_model.dart';
import 'package:mini_projet/models/user_model.dart';
import 'package:mini_projet/pages/favorites_page.dart';
import 'package:mini_projet/pages/home_page.dart';

class DishesPage extends StatefulWidget {
  const DishesPage({super.key});

  @override
  State<DishesPage> createState() => _DishesPageState();
}

class _DishesPageState extends State<DishesPage> {
  late Future<List<DishModel>?> dishes;
  late Future<UserModel> user;
  late bool isAdmin;
  getDishes() async {
    setState(() {
      dishes = Firestore.getDishes();
    });
  }

  getUser() {
    user = Firestore.getUser();
  }

  @override
  void initState() {
    getUser();
    getDishes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController dishNameController = TextEditingController();

    return FutureBuilder<UserModel>(
        future: user,
        builder: (context, user) {
          return user.hasData
              ? Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: const Text("Dishes"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          if (user.data!.isAdmin) {
                            Auth().signOut();
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FavoritesPage(),
                                )).then((_) => getDishes());
                          }
                        },
                        icon: Icon(
                            user.data!.isAdmin ? Icons.logout : Icons.favorite),
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
                          leading: Icon(
                            user.data!.isAdmin
                                ? Icons.my_library_add
                                : Icons.favorite_rounded,
                            size: 30,
                          ),
                          title: user.data!.isAdmin
                              ? const Text(
                                  'Add a new dish',
                                )
                              : const Text(
                                  'View favorites',
                                ),
                          onTap: () {
                            Navigator.pop(context);
                            if (user.data!.isAdmin) {
                              newDishDialog(context, dishNameController);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FavoritesPage(),
                                ),
                              ).then((_) => getDishes());
                            }
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
                                MaterialPageRoute(
                                    builder: ((context) => const HomePage())),
                                (route) => false);
                          },
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: user.data!.isAdmin
                      ? FloatingActionButton(
                          onPressed: () {
                            newDishDialog(context, dishNameController);
                          },
                          child: const Icon(Icons.add),
                        )
                      : null,
                  body: FutureBuilder<List<DishModel>?>(
                      future: dishes,
                      builder: (context, dishes) {
                        return dishes.hasData
                            ? ListView.builder(
                                itemCount: dishes.data!.length,
                                itemBuilder: ((context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 15),
                                    child: ListTile(
                                      tileColor: Colors.green[50],
                                      title: Text(
                                        dishes.data![index].name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(
                                            user.data!.isAdmin
                                                ? Icons.delete
                                                : dishes.data![index]
                                                        .isFavorite!
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed: () {
                                            if (user.data!.isAdmin) {
                                              Firestore.deleteDish(
                                                  dishes.data![index].id!);
                                            } else if (dishes
                                                .data![index].isFavorite!) {
                                              Firestore.removeFavorite(
                                                  dishes.data![index].id!);
                                            } else {
                                              Firestore.addFavorite(
                                                  dishes.data![index].id!);
                                            }
                                            getDishes();
                                          }),
                                    ),
                                  );
                                }),
                              )
                            : const Center(child: CircularProgressIndicator());
                      }))
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  newDishDialog(
      BuildContext context, TextEditingController dishNameController) {
    showBottomSheet(
        context: context,
        builder: (context) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.green[50],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Add a new dish",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: dishNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Dish name"),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () {
                            if (dishNameController.text != "") {
                              Firestore.addDish(dishNameController.text);
                              dishNameController.text = "";
                              Navigator.pop(context);
                              getDishes();
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  content: Text("Dish name shouldn't be empty"),
                                ),
                              );
                            }
                          },
                          child: const Text("Confirm")),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ));
  }
}
