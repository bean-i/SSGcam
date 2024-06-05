import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ssgcam/config.dart';

class AuthService {
  final String baseUrl = 'http://$ipAddress:3001/api/users';

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': username,
        'user_pw': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}
