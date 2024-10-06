/*
// transaction_manager.dart
import 'data_models.dart';

class TransactionManager {
  Map<String, List<Transaction>> userTransactions = {}; // Store transactions for each user

  // Add a transaction for a specific user
  void addTransaction(String userName, String type, double amount, String? description) {
    final transaction = Transaction(
      type: type,
      amount: amount,
      description: description,
      date: DateTime.now(),
    );

    if (userTransactions.containsKey(userName)) {
      userTransactions[userName]!.add(transaction);
    } else {
      userTransactions[userName] = [transaction];
    }
  }

  // Get all transactions for a specific user
  List<Transaction> getTransactionsForUser(String userName) {
    return userTransactions[userName] ?? [];
  }

  // Calculate total balance for a specific user (sum of creditor and debtor amounts)
  double calculateTotalForUser(String userName) {
    double total = 0;
    if (userTransactions.containsKey(userName)) {
      userTransactions[userName]!.forEach((transaction) {
        if (transaction.type == 'creditor') {
          total += transaction.amount;
        } else {
          total -= transaction.amount;
        }
      });
    }
    return total;
  }
}
*/

import 'data_models.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionManager {
  Map<String, List<Transaction>> userTransactions = {};

  // Add a transaction for a specific user and persist it to local storage
  Future<void> addTransaction(String userName, String type, double amount, String? description) async {
    final transaction = Transaction(
      type: type,
      amount: amount,
      description: description,
      date: DateTime.now(),
    );

    if (userTransactions.containsKey(userName)) {
      userTransactions[userName]!.add(transaction);
    } else {
      userTransactions[userName] = [transaction];
    }

    // Save transactions to local storage
    await _saveTransactionsToLocalStorage();
  }

  // Get all transactions for a specific user
  List<Transaction> getTransactionsForUser(String userName) {
    return userTransactions[userName] ?? [];
  }

  // Calculate total balance for a specific user (sum of creditor and debtor amounts)
  double calculateTotalForUser(String userName) {
    double total = 0;
    if (userTransactions.containsKey(userName)) {
      userTransactions[userName]!.forEach((transaction) {
        if (transaction.type == 'creditor') {
          total += transaction.amount;
        } else {
          total -= transaction.amount;
        }
      });
    }
    return total;
  }

  // Load transactions from local storage
  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsData = prefs.getString('userTransactions');

    if (transactionsData != null) {
      final Map<String, dynamic> decodedData = json.decode(transactionsData);
      userTransactions = decodedData.map((key, value) {
        return MapEntry(key, (value as List<dynamic>).map((e) => Transaction.fromJson(e)).toList());
      });
    }
  }

  // Save transactions to local storage
  Future<void> _saveTransactionsToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String transactionsData = json.encode(userTransactions.map((key, value) {
      return MapEntry(key, value.map((e) => e.toJson()).toList());
    }));

    await prefs.setString('userTransactions', transactionsData);
  }
}