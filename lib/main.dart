import 'package:flutter/material.dart';
import 'ui/user_list_screen.dart'; // Import the user list screen UI
import 'ui/transactions_screen.dart'; // Import the transactions screen UI

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(), // Set UserListScreen as the initial screen
      routes: {
        '/transactions': (context) => TransactionsScreen(), // Define the route to the transactions screen
      },
    );
  }
}
