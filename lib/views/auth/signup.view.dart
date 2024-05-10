import 'package:bapp/models/user.model.dart';
import 'package:bapp/services/auth.service.dart';
import 'package:bapp/services/user.service.dart';
import 'package:bapp/utils/index.dart';
import 'package:bapp/views/home/home.view.dart';
import 'package:bapp/widgets/custom.button.dart';
import 'package:bapp/widgets/custom.input.field.dart';
import 'package:bapp/widgets/custom.title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String? _selectedTheme;
  final AuthService _authService =
      AuthService(); // Assuming AuthService includes signup method
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomTitle(title: 'Registration'),
              const SizedBox(height: 20),
              CustomInputField(
                  controller: _nameController,
                  labelText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              CustomInputField(
                  controller: _phoneController,
                  labelText: 'Phone No',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              CustomInputField(
                  controller: _addressController,
                  labelText: 'Address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              CustomInputField(
                  controller: _cityController,
                  labelText: 'City',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  }),
              const SizedBox(height: 10),
              CustomInputField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter an email';
                  if (!value.contains('@')) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomInputField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a password';
                  if (value.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                isExpanded: true,
                value: _selectedTheme,
                items: ['Green', 'Red', 'Grey'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedTheme = newValue;
                  });
                },
                hint: Text('Select Theme'),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Create',
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    try {
                      User? user =
                          await _authService.createUserWithEmailAndPassword(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                      if (user != null) {
                        // Store additional user data in Firestore
                        await _userService.saveUser(UserModel(
                          name: _nameController.text,
                          phone: _phoneController.text,
                          address: _addressController.text,
                          city: _cityController.text,
                          email: _emailController.text,
                          themeColor: getThemeColor(_selectedTheme),
                        ));
                        // Update local preferences
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt("color", getThemeColor(_selectedTheme));
                        context.navigator(context, const HomeView());
                      }
                    } on FirebaseAuthException catch (e) {
                      showErrorDialog(
                          context, e.message ?? "An error occurred");
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getThemeColor(String? theme) {
    switch (theme) {
      case "Red":
        return 0;
      case "Green":
        return 1;
      case "Grey":
        return 2;
      default:
        return 0;
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
