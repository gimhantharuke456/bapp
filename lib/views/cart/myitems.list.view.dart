import 'package:bapp/models/collection.model.dart';
import 'package:bapp/models/favourite.item.model.dart';
import 'package:bapp/services/collection.service.dart';
import 'package:bapp/services/favourite.item.service.dart';

import 'package:bapp/utils/index.dart';

import 'package:bapp/views/checkout/delivery.instructions.view.dart';
import 'package:bapp/widgets/custom.button.dart';
import 'package:bapp/widgets/item.details.card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyItemList extends StatefulWidget {
  const MyItemList({super.key});

  @override
  _MyItemListState createState() => _MyItemListState();
}

class _MyItemListState extends State<MyItemList> {
  final FavouriteItemService _favouriteItemService = FavouriteItemService();
  final CollectionService _collectionService = CollectionService();
  final _nameController = TextEditingController();
  List<FavouriteItemModel> _favouriteItems = [];
  List<CollectionModel> _collections = [];
  String? _selectedCollectionId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _fetchCollections();
    await _fetchFavouriteItems();
  }

  Future<void> _fetchCollections() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    try {
      List<CollectionModel> collections =
          await _collectionService.getCollections(userId);
      if (collections.isNotEmpty) {
        setState(() {
          _collections = collections;
          _selectedCollectionId =
              collections.first.id; // Select the first collection by default
        });
      }
    } catch (e) {
      print('Error fetching collections: $e');
    }
  }

  Future<void> _fetchFavouriteItems() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
      List<FavouriteItemModel> items =
          await _favouriteItemService.getFavouriteItems(userId);
      if (_selectedCollectionId == "all") {
        setState(() {
          _favouriteItems = items;
        });
        return;
      }

      setState(() {
        _favouriteItems = items
            .where((item) => item.collectionId == _selectedCollectionId)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching favourite items: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateItemQuantity(String docId, int newQuantity) async {
    if (newQuantity < 1) {
      await _favouriteItemService.deleteFavouriteItem(docId);
      _fetchFavouriteItems(); // Refresh the list
    } else {
      FavouriteItemModel updatedItem =
          _favouriteItems.firstWhere((item) => item.id == docId);
      updatedItem.setQty = newQuantity;
      await _favouriteItemService.updateFavouriteItem(docId, updatedItem);
      setState(() {});
    }
  }

  Future<void> _deleteFavouriteItem(String docId) async {
    await _favouriteItemService.deleteFavouriteItem(docId);
    _fetchFavouriteItems(); // Refresh the list after deletion
  }

  Future<void> _addOrUpdateCollection(bool isUpdating) async {
    if (_nameController.text.isNotEmpty) {
      CollectionModel collection = CollectionModel(
          name: _nameController.text,
          userId: FirebaseAuth.instance.currentUser?.uid ?? "");
      if (isUpdating) {
        //  await _collectionService.u(_selectedCollectionId!, collection);
      } else {
        await _collectionService.addCollection(collection);
      }
      _fetchCollections();
      Navigator.pop(context);
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourite Items'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add New Collection'),
              content: TextField(
                controller: _nameController,
                decoration:
                    const InputDecoration(hintText: "Enter collection name"),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _nameController.clear();
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () => _addOrUpdateCollection(false),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (_collections.isNotEmpty)
            Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                ChoiceChip(
                  selected: _selectedCollectionId == "all",
                  label: Text("All"),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedCollectionId = "all";
                      _fetchFavouriteItems();
                    });
                  },
                ),
                ..._collections.map((collection) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(collection.name),
                      selected: _selectedCollectionId == collection.id,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCollectionId = collection.id;
                          _fetchFavouriteItems(); // Re-fetch items based on the selected collection
                        });
                      },
                    ),
                  );
                }).toList(),
              ]),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _favouriteItems.length,
                    itemBuilder: (context, index) {
                      final item = _favouriteItems[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("Add this item to collection"),
                                      DropdownButtonFormField(
                                          items: [
                                            const DropdownMenuItem<String>(
                                              value: "all",
                                              child: Text("All"),
                                            ),
                                            ..._collections.map(
                                                (CollectionModel collection) {
                                              return DropdownMenuItem<String>(
                                                value: collection.id,
                                                child: Text(collection.name),
                                              );
                                            })
                                          ],
                                          onChanged: (value) async {
                                            item.setCollection = value ?? "all";
                                            await _favouriteItemService
                                                .updateFavouriteItem(
                                                    item.id!, item)
                                                .then((value) async {
                                              await _fetchCollections();
                                              await _fetchFavouriteItems();
                                              Navigator.pop(context);
                                            }).onError((error, stackTrace) =>
                                                    context.showSnackBar(
                                                        "Error while adding this item to collection"));
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          title: ItemsDetailsCard(itemIdl: item.itemId),
                          subtitle: Text('Quantity: ${item.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => _updateItemQuantity(
                                    item.id!, item.quantity - 1),
                              ),
                              Text('${item.quantity}',
                                  style: const TextStyle(fontSize: 18)),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _updateItemQuantity(
                                    item.id!, item.quantity + 1),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteFavouriteItem(item.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: CustomButton(
              text: "Proceed to checkout",
              onPressed: () {
                List<Map<String, dynamic>> cartItems = _favouriteItems
                    .map((e) => {
                          "quantity": e.quantity,
                          "itemId": e.itemId,
                        })
                    .toList();
                context.navigator(
                    context, DeliveryInstructionsScreen(itemIds: cartItems));
              },
            ),
          ),
        ],
      ),
    );
  }
}
