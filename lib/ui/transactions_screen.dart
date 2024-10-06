// import 'package:flutter/material.dart';
// import '../backend/transaction_manager.dart';
//
// class TransactionsScreen extends StatefulWidget {
//   @override
//   _TransactionsScreenState createState() => _TransactionsScreenState();
// }
//
// class _TransactionsScreenState extends State<TransactionsScreen> {
//   TransactionManager _transactionManager = TransactionManager(); // Manager to handle transactions
//
//   @override
//   Widget build(BuildContext context) {
//     final String friendName = ModalRoute.of(context)!.settings.arguments as String;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Transactions with $friendName'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _transactionManager.getTransactionsForUser(friendName).length,
//               itemBuilder: (context, index) {
//                 final transaction = _transactionManager.getTransactionsForUser(friendName)[index];
//                 return ListTile(
//                   title: Text(transaction.description ?? 'No description'),
//                   subtitle: Text(transaction.date.toString()),
//                   trailing: Text(
//                     "${transaction.type == 'creditor' ? '+' : '-'} \$${transaction.amount}",
//                     style: TextStyle(
//                       color: transaction.type == 'creditor' ? Colors.green : Colors.red,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Total:'),
//                 Text(
//                   _transactionManager.calculateTotalForUser(friendName).toStringAsFixed(2),
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: _transactionManager.calculateTotalForUser(friendName) >= 0 ? Colors.green : Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _addTransactionWidget(friendName),
//         ],
//       ),
//     );
//   }
//
//   // Widget to add new transactions
//   Widget _addTransactionWidget(String friendName) {
//     TextEditingController _amountController = TextEditingController();
//     TextEditingController _descriptionController = TextEditingController();
//
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           TextField(
//             controller: _amountController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(labelText: 'Amount'),
//           ),
//           TextField(
//             controller: _descriptionController,
//             decoration: InputDecoration(labelText: 'Description (optional)'),
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   if (_amountController.text.isNotEmpty) {
//                     double amount = double.parse(_amountController.text);
//                     _addTransaction(friendName, 'creditor', amount, _descriptionController.text);
//                   }
//                 },
//                 child: Text('+ Money (Creditor)'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_amountController.text.isNotEmpty) {
//                     double amount = double.parse(_amountController.text);
//                     _addTransaction(friendName, 'debtor', amount, _descriptionController.text);
//                   }
//                 },
//                 child: Text('- Money (Debtor)'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Add a transaction for creditor or debtor
//   void _addTransaction(String friendName, String type, double amount, String description) {
//     setState(() {
//       _transactionManager.addTransaction(friendName, type, amount, description);
//     });
//   }
// }

import 'package:flutter/material.dart';
import '../backend/transaction_manager.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  TransactionManager _transactionManager = TransactionManager(); // Manager to handle transactions
  bool _isLoading = true; // To show a loading indicator while data is being loaded

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    await _transactionManager.loadTransactions(); // Load transactions from local storage
    setState(() {
      _isLoading = false; // Set loading to false when done
    });
  }

  @override
  Widget build(BuildContext context) {
    final String friendName = ModalRoute.of(context)!.settings.arguments as String;

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions with $friendName'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _transactionManager.getTransactionsForUser(friendName).length,
              itemBuilder: (context, index) {
                final transaction = _transactionManager.getTransactionsForUser(friendName)[index];
                return ListTile(
                  title: Text(transaction.description ?? 'No description'),
                  subtitle: Text(transaction.date.toString()),
                  trailing: Text(
                    "${transaction.type == 'creditor' ? '+' : '-'} \$${transaction.amount}",
                    style: TextStyle(
                      color: transaction.type == 'creditor' ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:'),
                Text(
                  _transactionManager.calculateTotalForUser(friendName).toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _transactionManager.calculateTotalForUser(friendName) >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          _addTransactionWidget(friendName),
        ],
      ),
    );
  }

  Widget _addTransactionWidget(String friendName) {
    TextEditingController _amountController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Amount'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description (optional)'),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_amountController.text.isNotEmpty) {
                    double amount = double.parse(_amountController.text);
                    _addTransaction(friendName, 'creditor', amount, _descriptionController.text);
                  }
                },
                child: Text('+ Money (Creditor)'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_amountController.text.isNotEmpty) {
                    double amount = double.parse(_amountController.text);
                    _addTransaction(friendName, 'debtor', amount, _descriptionController.text);
                  }
                },
                child: Text('- Money (Debtor)'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addTransaction(String friendName, String type, double amount, String description) {
    setState(() {
      _transactionManager.addTransaction(friendName, type, amount, description);
    });
  }
}
