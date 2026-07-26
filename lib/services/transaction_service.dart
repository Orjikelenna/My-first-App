import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/transaction.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _transactions => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('transactions');

  Future<void> addTransaction(
    String title,
    double amount,
    bool isIncome,
    String category,
  ) async {
    await _transactions.add({
      'title': title,
      'amount': amount,
      'isIncome': isIncome,
      'category': category,
      'date': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTransaction(String id) async {
    await _transactions.doc(id).delete();
  }

  Stream<List<FinanceTransaction>> getTransactions() {
    return _transactions.orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return FinanceTransaction.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }
}
