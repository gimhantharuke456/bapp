import 'package:flutter/material.dart';

class CheckoutView extends StatefulWidget {
  final List<Map<String, dynamic>> itemIds;

  const CheckoutView({super.key, required this.itemIds});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
