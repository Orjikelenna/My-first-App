import 'dart:convert';

import 'package:http/http.dart' as http;

class PaymentService {
  final String _secretKey =
      'sk_test_0ce0cccd28032a7ce14d8f26022fc75461feb2d1'; // replace with your secret key

  // Initialize a payment transaction
  Future<Map<String, dynamic>> initializePayment({
    required String email,
    required int amountInKobo, // Paystack uses kobo (100 kobo = 1 naira)
  }) async {
    final response = await http.post(
      Uri.parse('https://api.paystack.co/transaction/initialize'),
      headers: {
        'Authorization': 'Bearer $_secretKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'amount': amountInKobo}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to initialize payment');
    }
  }

  // Verify a payment transaction
  Future<Map<String, dynamic>> verifyPayment(String reference) async {
    final response = await http.get(
      Uri.parse('https://api.paystack.co/transaction/verify/$reference'),
      headers: {'Authorization': 'Bearer $_secretKey'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify payment');
    }
  }
}
