import 'package:bapp/app.styles.dart';
import 'package:bapp/db/mongodb.dart';
import 'package:bapp/providers/item.provider.dart';
import 'package:bapp/views/auth/login.view.dart';
import 'package:bapp/views/home/home.view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbConnect().open();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ItemProvider(),
        )
      ],
      child: MaterialApp(
        home: FirebaseAuth.instance.currentUser != null
            ? const HomeView()
            : LoginScreen(),
        theme: AppStyles().buildThemeData(),
      ),
    );
  }
}
