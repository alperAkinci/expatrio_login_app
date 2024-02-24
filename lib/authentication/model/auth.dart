import 'dart:convert' show json;

class Auth {
  final String? token;
  final String? message;
  final int? userId;

  const Auth({this.token, this.message, this.userId});

  /// Parses the string and returns the resulting Json object as [Auth].
  factory Auth.fromJson(String data) {
    return Auth.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  factory Auth.fromMap(Map<String, dynamic> data) => Auth(
        token: data['accessToken'] as String?,
        message: data['message'] as String?,
        userId: data['userId'] as int?,
      );

  /// Converts [Auth] to a JSON string.
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'accessToken': token,
        'message': message,
        'userId': userId,
      };
}
