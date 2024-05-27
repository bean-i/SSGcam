import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000/api/users';

  Future<bool> login(String userId, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'user_pw': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['loginSuccess']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseBody['token']);
        return true;
      }
    }
    return false;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
