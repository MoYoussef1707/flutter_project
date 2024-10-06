import 'package:flutter/material.dart';
import '../backend/user_manager.dart'; // Import your backend logic

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  UserManager _userManager = UserManager(); // UserManager for handling backend logic

  // Method to send a request to the added user (for Person type)
  void _sendRequestToUser(String name) {
    print("Request sent to $name. Waiting for their acceptance...");

    // Simulate user acceptance (you can replace this with actual logic)
    Future.delayed(Duration(seconds: 3), () {
      print("$name has accepted your request.");
      _addFriend(name, isPerson: true); // Add user after request is accepted
    });
  }

  // Method to add a friend or utility to the list
  void _addFriend(String name, {required bool isPerson}) {
    setState(() {
      _userManager.addFriend(name, isPerson); // Add the user to the list via UserManager
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
      ),
      body: ListView.builder(
        itemCount: _userManager.friends.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_userManager.friends[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Edit functionality here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _userManager.removeFriend(_userManager.friends[index].name);
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/transactions',
                arguments: _userManager.friends[index].name,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddFriendDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  _displayAddFriendDialog() async {
    TextEditingController _textFieldController = TextEditingController();
    String? userType; // This will store the selected user type

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Use StatefulBuilder to manage the state inside the dialog
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add New Friend or Utility'),
              content: SingleChildScrollView( // This will allow content to scroll if the keyboard overlaps
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _textFieldController,
                      decoration: InputDecoration(
                        hintText: "Enter friend's or utility's name",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      value: userType,
                      isExpanded: true, // Ensures the dropdown takes the full width
                      hint: Text('Select Type'),
                      items: <String>['Person', 'Utilities'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          userType = value; // Update the selected value
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text('Add'),
                  onPressed: () {
                    if (userType != null) {
                      if (userType == 'Person') {
                        _sendRequestToUser(_textFieldController.text);
                      } else if (userType == 'Utilities') {
                        _addFriend(_textFieldController.text, isPerson: false);
                      }
                      Navigator.pop(context);
                    } else {
                      print("Please select a type.");
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
