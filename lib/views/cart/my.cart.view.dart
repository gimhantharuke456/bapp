import 'package:bapp/models/cart.item.model.dart';
import 'package:bapp/services/cart.item.service.dart';
import 'package:bapp/utils/index.dart';
import 'package:bapp/views/checkout/delivery.instructions.view.dart';
import 'package:bapp/widgets/custom.button.dart';
import 'package:bapp/widgets/item.details.card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyCartView extends StatefulWidget {
  const MyCartView({super.key});

  @override
  _MyCartViewState createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {
  final CartItemService _cartItemService = CartItemService();
  List<CartItemModel> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    try {
      List<CartItemModel> items = await _cartItemService
          .getCartItems(FirebaseAuth.instance.currentUser?.uid ?? "");
      setState(() {
        _cartItems = items;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
      setState(() => _isLoading = false);
    }
  }

  void _updateItemQuantity(String docId, int quantity) async {
    if (quantity < 1) {
      await _cartItemService.deleteCartItem(docId);
    } else {
      CartItemModel updatedItem =
          _cartItems.firstWhere((item) => item.id == docId);
      updatedItem.setQty = quantity;
      await _cartItemService.updateCartItem(docId, updatedItem);
    }
    await _fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.shopping_cart),
                          title: ItemsDetailsCard(itemIdl: item.itemId),
                          subtitle: Text('Price: LKR ${item.price}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => _updateItemQuantity(
                                    item.id!, item.quantity - 1),
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(fontSize: 24),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => _updateItemQuantity(
                                    item.id!, item.quantity + 1),
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
                      List<Map<String, dynamic>> cartItems = _cartItems
                          .map((e) => {
                                "quantity": e.quantity,
                                "itemId": e.itemId,
                              })
                          .toList();
                      context.navigator(context,
                          DeliveryInstructionsScreen(itemIds: cartItems));
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
