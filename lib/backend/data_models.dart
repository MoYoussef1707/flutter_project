// // data_models.dart
// class User {
//   String name;
//   bool isPerson;
//   List<Transaction> transactions = []; // Each user now has their own list of transactions
//
//   User({required this.name, required this.isPerson});
// }
//
// class Transaction {
//   String type; // 'creditor' or 'debtor'
//   double amount;
//   String? description;
//   DateTime date;
//
//   Transaction({
//     required this.type,
//     required this.amount,
//     this.description,
//     required this.date,
//   });
// }

//data_models.dart
class User {
  String name;
  bool isPerson;
  List<Transaction> transactions = []; // Each user now has their own list of transactions

  User({required this.name, required this.isPerson});
}

class Transaction {
  String type; // 'creditor' or 'debtor'
  double amount;
  String? description;
  DateTime date;

  Transaction({
    required this.type,
    required this.amount,
    this.description,
    required this.date,
  });

  // Convert Transaction object to JSON
  Map<String, dynamic> toJson() => {
    'type': type,
    'amount': amount,
    'description': description,
    'date': date.toIso8601String(),
  };

  // Create a Transaction object from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'],
      amount: json['amount'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }
}
