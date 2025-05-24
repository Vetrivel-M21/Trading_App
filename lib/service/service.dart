import 'dart:convert';
import 'package:http/http.dart' as http;

class AppService {
  final String url = "http://192.168.2.34:29091/getBankMaster";
  final String  registerUrl = 'http://192.168.2.34:29091/clientRegister';
  final String loginUrl  = 'http://192.168.2.34:29091/clientLogin';
  late final Map<String, dynamic> responseData;

  Future<List<Map<String, dynamic>>> getBankDetails() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
     
      var decodedResponse = jsonDecode(response.body);


      if (decodedResponse is Map<String, dynamic> && decodedResponse['resp'] is List) {
        
        var banksList = decodedResponse['resp'] as List;
        return List<Map<String, dynamic>>.from(banksList);

      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load bank details');
    }
  }
Future<Map<String, dynamic>> createUser(Map userData) async {
  final response = await http.post(
    Uri.parse(registerUrl),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(userData),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to register user');
  }
}
  

  Future<http.Response> logIn(Map loginData) async{
      return http.post(
        Uri.parse(loginUrl),
        headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginData),
      );
  }
}
