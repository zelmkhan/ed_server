import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import '../../global_constants.dart';

// main - 6720574493:AAHre-5lbLHbFPbERbcXpMUSdUChFwq7klo
// localtest - 5768337691:AAH5YkoiEuPk8-FZa32hStHTqXiLPtAEhx8
bool validation(String payload, String hash) {
  var dataCheckString = payload;
  var hmacSecretKey = Hmac(sha256, utf8.encode('WebAppData'));
  var secretKey = hmacSecretKey.convert(utf8.encode(GlobalConstants.botToken));
  var hashSecretKey = Hmac(sha256, secretKey.bytes);
  var checkHash = hashSecretKey.convert(utf8.encode(dataCheckString));
  if (HEX.encode(checkHash.bytes) != hash) {
    return false;
  }
  return true;
}