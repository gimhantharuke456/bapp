import 'package:bapp/app.styles.dart';
import 'package:bapp/models/delivery.address.model.dart';
import 'package:bapp/services/delivery.details.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeliveryDetailsView extends StatefulWidget {
  const DeliveryDetailsView({super.key});

  @override
  _DeliveryDetailsViewState createState() => _DeliveryDetailsViewState();
}

class _DeliveryDetailsViewState extends State<DeliveryDetailsView> {
  final _deliveryDetailsService = DeliveryDetailsService();
  final TextEditingController _homeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();

  List<DeliveryDetails> _deliveryDetails = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeliveryDetails();
  }

  Future<void> _fetchDeliveryDetails() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    try {
      List<DeliveryDetails> details =
          await _deliveryDetailsService.getDeliveryDetailsByUserId(userId);
      setState(() {
        _deliveryDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching delivery details: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showDetailDialog({DeliveryDetails? details}) {
    if (details != null) {
      _homeController.text = details.home;
      _cityController.text = details.city;
      _districtController.text = details.district;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(details == null
            ? 'Add New Delivery Details'
            : 'Update Delivery Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _homeController,
                decoration: const InputDecoration(hintText: 'Home Address'),
              ),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(hintText: 'City'),
              ),
              TextField(
                controller: _districtController,
                decoration: const InputDecoration(hintText: 'District'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _homeController.clear();
              _cityController.clear();
              _districtController.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final String userId =
                  FirebaseAuth.instance.currentUser?.uid ?? "";
              final newDetails = DeliveryDetails(
                id: details?.id ?? '',
                home: _homeController.text,
                city: _cityController.text,
                district: _districtController.text,
                userId: userId,
              );
              if (details == null) {
                await _deliveryDetailsService.addDeliveryDetails(newDetails);
              } else {
                await _deliveryDetailsService.updateDeliveryDetails(
                    details.id!, newDetails);
              }
              _fetchDeliveryDetails();
              Navigator.of(context).pop();
              _homeController.clear();
              _cityController.clear();
              _districtController.clear();
            },
            child: Text(details == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _deliveryDetails.isEmpty
              ? const Center(
                  child: Text("Don't have any delivery details"),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _deliveryDetails.length,
                  itemBuilder: (context, index) {
                    final detail = _deliveryDetails[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                            '${detail.home}, ${detail.city}, ${detail.district}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _showDetailDialog(details: detail),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await _deliveryDetailsService
                                    .deleteDeliveryDetails(detail.id!);
                                _fetchDeliveryDetails();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyles().primaryColor(),
        onPressed: () => _showDetailDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Add Delivery Details',
      ),
    );
  }
}
