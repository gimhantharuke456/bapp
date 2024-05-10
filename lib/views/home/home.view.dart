import 'package:bapp/app.styles.dart';
import 'package:bapp/models/cart.item.model.dart';
import 'package:bapp/models/favourite.item.model.dart';
import 'package:bapp/models/item.model.dart';
import 'package:bapp/providers/item.provider.dart';
import 'package:bapp/services/cart.item.service.dart';
import 'package:bapp/services/favourite.item.service.dart';
import 'package:bapp/services/item.service.dart';
import 'package:bapp/services/voice.service.dart';
import 'package:bapp/utils/index.dart';
import 'package:bapp/widgets/app.drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemService itemService = ItemService();
    final itemProvider = Provider.of<ItemProvider>(context);
    VoiceService voiceService = VoiceService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          voiceService
              .initializeSpeech()
              .then((value) => voiceService.startListening(onResult: (text) {
                    voiceService.navigate(text, context);
                  }));
        },
        child: Icon(
          Icons.mic,
          color: AppStyles().primaryColor(),
        ),
      ),
      body: FutureBuilder<List<Item>>(
        future: itemService.fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final items = snapshot.data!;
            itemProvider.setItems = items;
            if (items.isEmpty) {
              return const Center(
                child: Text("No items at the moment"),
              );
            }
            return ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    title: Text(item.itemName),
                    subtitle: Text(
                        'Price: \$${item.unitPrice} - Qty: ${item.quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            CartItemModel cartItemModel = CartItemModel(
                              itemId: item.id,
                              userId:
                                  FirebaseAuth.instance.currentUser?.uid ?? "",
                              price: item.unitPrice.toDouble(),
                            );
                            CartItemService()
                                .addCartItem(cartItemModel)
                                .then(
                                  (value) => context
                                      .showSnackBar("Item added to cart"),
                                )
                                .catchError((error) {
                              context.showSnackBar(
                                  "Error while adding item to cart");
                            });
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            color: AppStyles().primaryColor(),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            FavouriteItemModel i = FavouriteItemModel(
                              itemId: item.id,
                              userId:
                                  FirebaseAuth.instance.currentUser?.uid ?? "",
                            );
                            FavouriteItemService()
                                .addFavouriteItem(i)
                                .then((value) =>
                                    context.showSnackBar("Item favorited"))
                                .onError((error, stackTrace) =>
                                    context.showSnackBar(
                                        "Error item adding to your list"));
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: AppStyles().primaryColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No items found.'));
          }
        },
      ),
    );
  }
}
