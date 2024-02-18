import 'dart:convert' show json;

class Auth {
  final String? token;
  final String? message;

  const Auth({this.token, this.message});

  /// Parses the string and returns the resulting Json object as [Auth].
  factory Auth.fromJson(String data) {
    return Auth.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  factory Auth.fromMap(Map<String, dynamic> data) => Auth(
        token: data['accessToken'] as String?,
        message: data['message'] as String?,
      );

  /// Converts [Auth] to a JSON string.
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'accessToken': token,
        'message': message,
      };
}
