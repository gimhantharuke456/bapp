import 'package:bapp/models/delivery.address.model.dart';
import 'package:bapp/models/order.model.dart';
import 'package:bapp/services/delivery.details.service.dart';
import 'package:bapp/utils/index.dart';
import 'package:bapp/views/checkout/carddetails.view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bapp/app.styles.dart';
import 'package:bapp/widgets/custom.button.dart';
import 'package:bapp/widgets/custom.input.field.dart';

class DeliveryInstructionsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> itemIds;

  const DeliveryInstructionsScreen({super.key, required this.itemIds});

  @override
  _DeliveryInstructionsScreenState createState() =>
      _DeliveryInstructionsScreenState();
}

class _DeliveryInstructionsScreenState
    extends State<DeliveryInstructionsScreen> {
  final DeliveryDetailsService _deliveryDetailsService =
      DeliveryDetailsService();
  final TextEditingController _homeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDeliveryDetails();
  }

  void _loadDeliveryDetails() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    List<DeliveryDetails?> details =
        await _deliveryDetailsService.getDeliveryDetailsByUserId(userId);
    if (details.isNotEmpty) {
      _homeController.text = details[0]!.home;
      _cityController.text = details[0]!.city;
      _districtController.text = details[0]!.district;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Instructions"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Home :", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            CustomInputField(
              controller: _homeController,
              labelText: "Enter your home address",
            ),
            const SizedBox(height: 16),
            const Text("City :", style: TextStyle(fontSize: 16)),
            CustomInputField(
              controller: _cityController,
              labelText: "Enter your city",
            ),
            const SizedBox(height: 16),
            const Text("District :", style: TextStyle(fontSize: 16)),
            CustomInputField(
              controller: _districtController,
              labelText: "Enter your district",
            ),
            const SizedBox(height: 30),
            Center(
              child: Icon(Icons.location_on,
                  size: 50, color: AppStyles().primaryColor()),
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                Order order = Order(
                    itemList: widget.itemIds,
                    home: _homeController.text,
                    city: _cityController.text,
                    district: _districtController.text,
                    userId: FirebaseAuth.instance.currentUser?.uid ?? "");
                context.navigator(context, CardDetailsView(order: order));
              },
              text: "Save & Continue",
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    size: 50,
                    color: AppStyles().primaryColor(),
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.mic,
                    size: 50,
                    color: AppStyles().primaryColor(),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
