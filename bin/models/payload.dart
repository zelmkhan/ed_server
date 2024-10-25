import 'dart:convert';

class Payload {
  final String authDate;
  final String? queryId;
  final User user;
  final String hash;
  final String? ref;

  Payload({required this.authDate, required this.queryId, required this.user, required this.hash, required this.ref});

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      authDate: json['auth_date'], 
      queryId: json['query_id'], 
      user: User.fromJson(jsonDecode(json['user'])),
      hash: json['hash'],
      ref: json['ref']
    );
  }

  validationStructure() => "auth_date=$authDate\nquery_id=$queryId\nuser=${user.toRaw()}";
}

class User {
  final num id;
  final String firstname;
  final String lastname;
  final String username;
  final String languageCode;
  final bool? isPremium;
  final bool allowsWriteToPm;

  User({required this.id, required this.firstname, required this.lastname, required this.username, required this.languageCode, required this.isPremium, required this.allowsWriteToPm});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], 
      firstname: json['first_name'], 
      lastname: json['last_name'], 
      username: json['username'], 
      languageCode: json['language_code'], 
      isPremium: json['is_premium'],
      allowsWriteToPm: json['allows_write_to_pm']);
  }

  toRaw() => json.encode({
    'id': id,
    'first_name': firstname,
    'last_name': lastname,
    'username': username,
    'language_code': languageCode,
    if (isPremium != null)
    'is_premium': isPremium,
    'allows_write_to_pm': allowsWriteToPm
  });


}