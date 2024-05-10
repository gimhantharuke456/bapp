import 'package:bapp/models/user.model.dart';
import 'package:bapp/services/auth.service.dart';
import 'package:bapp/utils/index.dart';
import 'package:bapp/views/auth/login.view.dart';
import 'package:bapp/views/cart/myitems.list.view.dart';
import 'package:bapp/views/cart/my.cart.view.dart';
import 'package:bapp/views/orderview/my.orders.view.dart';
import 'package:bapp/views/profile/delivery.details.view.dart';
import 'package:bapp/views/profile/user.profile.view.dart';
import 'package:flutter/material.dart';
import 'package:bapp/services/user.service.dart'; // Make sure to import your UserService

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService =
        UserService(); // Assuming UserService has getUser() method

    return Drawer(
      child: ListView(
        children: <Widget>[
          FutureBuilder<UserModel?>(
            future: userService.getUser(), // Fetch the user
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: ListTile(
                    title: Text('Error loading user data'),
                  ),
                );
              }
              if (snapshot.hasData) {
                final user = snapshot.data!;
                return UserAccountsDrawerHeader(
                  accountName: Text(user.name),
                  accountEmail: Text(user.email),
                  currentAccountPicture: CircleAvatar(
                    child: Text(
                        user.name[0]), // Display the first letter of the name
                  ),
                );
              }
              return const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: ListTile(
                  title: Text('No user data available'),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Profile'),
            onTap: () {
              context.navigator(context, const UserProfileScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_outline),
            title: Text('My List'),
            onTap: () {
              context.navigator(context, const MyItemList());
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('My Cart'),
            onTap: () {
              context.navigator(context, const MyCartView());
            },
          ),
          ListTile(
            leading: Icon(Icons.laptop),
            title: Text('My Orders'),
            onTap: () {
              context.navigator(context, const MyOrdersView());
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Delivery Details'),
            onTap: () {
              context.navigator(context, const DeliveryDetailsView());
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              AuthService().signOut().then((value) =>
                  context.navigator(context, LoginScreen(), shouldBack: false));
            },
          ),
        ],
      ),
    );
  }
}
