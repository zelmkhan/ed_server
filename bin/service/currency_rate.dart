import 'dart:convert';

import 'package:http/http.dart' as http;

class CurrencyRate {

  static final String apiKey = "A5ADF662-61A2-4143-9F2F-400052599E56";

  static Future getRate({required String baseCurrency, required String quoteCurrency}) async {
    try {
      var response = await http.get(Uri.parse("https://rest.coinapi.io/v1/exchangerate/$baseCurrency/$quoteCurrency"), headers: {"Authorization": apiKey});
      return json.decode(response.body)['rate'];
    } catch (e) {
      return null;
    }
  }

}