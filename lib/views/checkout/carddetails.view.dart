import 'package:bapp/services/order.service.dart';
import 'package:bapp/utils/index.dart';
import 'package:bapp/views/home/home.view.dart';
import 'package:bapp/widgets/custom.button.dart';
import 'package:flutter/material.dart';
import 'package:bapp/models/order.model.dart';

class CardDetailsView extends StatefulWidget {
  final Order order;
  const CardDetailsView({super.key, required this.order});

  @override
  State<CardDetailsView> createState() => _CardDetailsViewState();
}

class _CardDetailsViewState extends State<CardDetailsView> {
  String _selectedCard = 'visa';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expMonthController = TextEditingController();
  final TextEditingController _expYearController = TextEditingController();
  final TextEditingController _cvnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: 'visa',
                    groupValue: _selectedCard,
                    onChanged: (value) {
                      setState(() {
                        _selectedCard = value!;
                      });
                    },
                  ),
                  Image.asset('assets/visa.png', width: 50, height: 30),
                  SizedBox(width: 20),
                  Radio<String>(
                    value: 'mastercard',
                    groupValue: _selectedCard,
                    onChanged: (value) {
                      setState(() {
                        _selectedCard = value!;
                      });
                    },
                  ),
                  Image.asset('assets/master.png', width: 50, height: 30),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLength: 16,
                controller: _cardNumberController,
                decoration: InputDecoration(
                  hintText: "Enter your card number",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 16) {
                    return 'Please enter a valid 16-digit card number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 2,
                      controller: _expMonthController,
                      decoration: InputDecoration(
                        hintText: "MM",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value)! > 12 ||
                            int.tryParse(value)! < 1) {
                          return 'Invalid month';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      maxLength: 4,
                      controller: _expYearController,
                      decoration: InputDecoration(
                        hintText: "YYYY",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        int currentYear = DateTime.now().year;
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value)! < currentYear) {
                          return 'Invalid year';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLength: 3,
                controller: _cvnController,
                decoration: InputDecoration(
                  hintText: "CVN",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 3) {
                    return 'Please enter a valid 3-digit CVN';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    OrderService().addOrder(widget.order).then((value) {
                      context.showSnackBar("Order placed successfully");
                      context.navigator(context, const HomeView(),
                          shouldBack: false);
                    }).catchError((error) {
                      context.showSnackBar("Error creating order");
                    });
                  }
                },
                text: "Pay",
              ),
              SizedBox(height: 10),
              CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Cancel",
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.volume_up, size: 50),
                    onPressed: () {}, // Implement sound
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.mic, size: 50),
                    onPressed: () {}, // Implement mic functionality
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
