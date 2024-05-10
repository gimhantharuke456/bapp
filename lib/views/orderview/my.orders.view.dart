import 'package:bapp/app.styles.dart';
import 'package:bapp/models/item.model.dart';
import 'package:bapp/models/order.model.dart';
import 'package:bapp/providers/item.provider.dart';
import 'package:bapp/services/order.service.dart';
import 'package:bapp/utils/index.dart';
import 'package:bapp/widgets/item.details.card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Order>>(
            future: OrderService().getOrdersByUserId(
                FirebaseAuth.instance.currentUser?.uid ?? ""),
            builder: (context, AsyncSnapshot<List<Order>> snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppStyles().primaryColor(),
                  ),
                );
              }
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("You don't have orders yet"),
                );
              }
              return ListView(
                children: snapshot.data!
                    .map(
                      (e) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Ordered Items",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const Divider(),
                              ...e.itemList.map((e) => ListTile(
                                    title: ItemsDetailsCard(
                                      itemIdl: e["itemId"],
                                    ),
                                    subtitle: Text(
                                        "Quantity : ${e["quantity"].toString()}"),
                                  )),
                              const Divider(),
                              Text(
                                'City :  ${e.city}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Home :  ${e.home}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await OrderService()
                                          .deleteOrder(e.id!)
                                          .then((value) {
                                        context.showSnackBar("Order deleted");
                                        setState(() {});
                                      }).catchError((err) {
                                        context.showSnackBar(
                                            "Error deleting order");
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            }),
      ),
    );
  }
}
