import 'package:bapp/services/auth.service.dart';
import 'package:bapp/services/authentication.bo.dart';
import 'package:bapp/services/voice.service.dart';
import 'package:bapp/utils/index.dart';
import 'package:bapp/views/auth/signup.view.dart';
import 'package:bapp/views/home/home.view.dart';
import 'package:bapp/widgets/custom.button.dart';
import 'package:bapp/widgets/custom.input.field.dart';
import 'package:bapp/widgets/custom.title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key})
      : super(key: key); // Added key for better state management

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final VoiceService _voiceService = VoiceService();
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _voiceService.initializeSpeech();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CustomTitle(
                title: 'Log In',
              ),
              const SizedBox(
                height: 48,
              ),
              const SizedBox(
                height: 32,
              ),
              CustomInputField(
                controller: _usernameController,
                labelText: 'Username',
              ),
              const SizedBox(
                height: 32,
              ),
              CustomInputField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true, // Obscure text for password field
              ),
              const SizedBox(
                height: 32,
              ),
              CustomButton(
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    await AuthService()
                        .signInWithEmailAndPassword(
                            _usernameController.text, _passwordController.text)
                        .then((value) => context.navigator(
                            context, const HomeView(), shouldBack: false))
                        .onError((error, stackTrace) =>
                            context.showSnackBar("Error while login in"));
                  }
                },
                text: "Signin",
              ),
              IconButton(
                iconSize: 70,
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  _authenticateWithBiometrics(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextButton(
                  onPressed: () {
                    context.navigator(context, RegistrationScreen());
                  },
                  child: const Text('Signup click here'),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      iconSize: 70,
                      icon: const Icon(Icons.volume_up),
                      onPressed: () {
                        _voiceService.speak(
                            'Please say your username followed by your password.');
                        _voiceService.startListening(onResult: (text) {
                          List<String> parts = text.split(' ');
                          if (parts.length >= 2) {
                            _usernameController.text = parts[0];
                            _passwordController.text = parts[1];
                          }
                        });
                      },
                    ),
                    IconButton(
                      iconSize: 70,
                      icon: const Icon(Icons.mic),
                      onPressed: () {
                        if (!_voiceService.isListening) {
                          _voiceService.startListening(onResult: (text) {
                            List<String> parts = text.split(' ');
                            if (parts.length >= 2) {
                              _usernameController.text = parts[0];
                              _passwordController.text = parts[1];
                            }
                          });
                        } else {
                          _voiceService.stopListening();
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    try {
      final isAuthenticated = await Authentication.authentication();
      if (isAuthenticated) {
        await FirebaseAuth.instance.signInAnonymously();
        context.navigator(context, HomeView(), shouldBack: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }
}
