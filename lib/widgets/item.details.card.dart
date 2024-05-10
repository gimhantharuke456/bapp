import 'package:bapp/models/item.model.dart';
import 'package:bapp/providers/item.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsDetailsCard extends StatefulWidget {
  final String itemIdl;
  const ItemsDetailsCard({super.key, required this.itemIdl});

  @override
  State<ItemsDetailsCard> createState() => _ItemsDetailsCardState();
}

class _ItemsDetailsCardState extends State<ItemsDetailsCard> {
  Item? item;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemProvider>(builder: (context, child, snap) {
      try {
        item =
            child.items.firstWhere((element) => element.id == widget.itemIdl);
      } catch (e) {}
      return item == null
          ? const Text("Item is delted by admin")
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(item!.itemName)],
            );
    });
  }
}
