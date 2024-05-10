import 'package:bapp/utils/index.dart';
import 'package:bapp/widgets/custom.button.dart';
import 'package:bapp/widgets/custom.input.field.dart';
import 'package:flutter/material.dart';
import 'package:bapp/models/user.model.dart'; // Adjust import as needed
import 'package:bapp/services/user.service.dart'; // Adjust import as needed

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    UserModel? user = await _userService.getUser();
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _addressController.text = user.address;
      _cityController.text = user.city;
    }
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      UserModel updatedUser = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text,
      );
      await _userService.saveUser(updatedUser).then(
          (value) => context.showSnackBar("Profile updated successfully"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomInputField(
                    labelText: "Name",
                    controller: _nameController,
                    validator: _requiredValidator),
                const SizedBox(
                  height: 16,
                ),
                CustomInputField(
                    controller: _emailController,
                    labelText: 'Email',
                    enabled: false,
                    validator: _emailValidator),
                const SizedBox(
                  height: 16,
                ),
                CustomInputField(
                    controller: _phoneController,
                    labelText: 'Phone No',
                    validator: _requiredValidator),
                const SizedBox(
                  height: 16,
                ),
                CustomInputField(
                    controller: _addressController,
                    labelText: 'Address',
                    validator: _requiredValidator),
                const SizedBox(
                  height: 16,
                ),
                CustomInputField(
                    controller: _cityController,
                    labelText: 'City',
                    validator: _requiredValidator),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(height: 20),
                CustomButton(
                    onPressed: _updateUserData, text: 'Update Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter this field';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
