// user_manager.dart
import 'data_models.dart';

class UserManager {
  List<User> friends = [];

  void addFriend(String name, bool isPerson) {
    friends.add(User(name: name, isPerson: isPerson));
  }

  void removeFriend(String name) {
    friends.removeWhere((friend) => friend.name == name);
  }

  User? getUser(String name) {
    try {
      return friends.firstWhere((friend) => friend.name == name);
    } catch (e) {
      return null; // Return null if the user is not found
    }
  }

  // Add a transaction for a specific user
  void addTransactionToUser(String userName, String type, double amount, String? description) {
    User? user = getUser(userName);
    if (user != null) {
      user.transactions.add(Transaction(
        type: type,
        amount: amount,
        description: description,
        date: DateTime.now(),
      ));
    }
  }

  // Calculate the total for a specific user
  double calculateTotalForUser(String userName) {
    User? user = getUser(userName);
    if (user != null) {
      double total = 0;
      user.transactions.forEach((transaction) {
        if (transaction.type == 'creditor') {
          total += transaction.amount;
        } else {
          total -= transaction.amount;
        }
      });
      return total;
    }
    return 0.0;
  }
}
