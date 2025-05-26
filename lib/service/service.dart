import 'dart:convert';
import 'package:http/http.dart' as http;

class AppService {
  final String url = "http://192.168.2.34:29091/getBankMaster";
  final String  registerUrl = 'http://192.168.2.34:29091/clientRegister';
  final String userloginUrl  = 'http://192.168.2.34:29091/clientLogin';
  final String adminLoginUrl = 'http://192.168.2.34:29091/adminLogin';
  final String getMyTradeUrl = 'http://192.168.2.34:29091/getTrade';
  final String getClientDataUrl = 'http://192.168.2.34:29091/getClientData';
  final String kycUpdateUrl = 'http://192.168.2.34:29091/kycApprovals';
  final String addStocksUrl = 'http://192.168.2.34:29091/insertStock';
  final String insertBankUrl = 'http://192.168.2.34:29091/insertBank';
  final String insertUserurl = 'http://192.168.2.34:29091/insertUser';
  final String getTradeAprovalurl = 'http://192.168.2.34:29091/getTradeApproval';
  final String userAprovalurl = 'http://192.168.2.34:29091/userApproval';
  
  late final Map<String, dynamic> responseData;
  // Function to get bank details
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

  //register user
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
  
  //user login
  Future<http.Response> UserlogIn(Map loginData) async{
      return http.post(
        Uri.parse(userloginUrl),
        headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginData),
      );
  }
//admin login
  Future<http.Response> AdminlogIn(Map loginData) async {
    return http.post(
      Uri.parse(adminLoginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(loginData),
    );


  }

  //get trade
  getMyTrade(Map ClientID) async {
    final response = await http.get(Uri.parse(getMyTradeUrl));

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);

      print(decodedResponse);
    } else {
      throw Exception('Failed to load trade details');
    }
  }
   
  Future<List<Map<String, dynamic>>> getClientData()async{
    final response = await http.get(Uri.parse(getClientDataUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if(data is Map<String, dynamic> && data['resp'] is List) {
        var clientList = data['resp'] as List;
        return List<Map<String, dynamic>>.from(clientList);
      } else if (data is List) {
        // If the response is already a list, we can use it directly
      } else {
        throw Exception('Unexpected response format');
        
      }
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load client data');
    }
   }

  //kyc update
  Future<http.Response> kycUpdate(Map<String, dynamic> kycData) async {
    return http.put(
      Uri.parse(kycUpdateUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(kycData),
    );
  }

  Future<bool> addStocks(Map<String, dynamic> stockData) async{
      final response = await http.post(
        Uri.parse(addStocksUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',

        },
        body: jsonEncode(stockData),
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'S') {
          return true;
        } else {
          throw Exception('Failed to add stock: ${decodedResponse['message']}');
        }
      } else {
        throw Exception('Failed to add stock');
      }
  }


   Future<bool> insertBank(Map<String, dynamic> bankData) async{
      final response = await http.post(
        Uri.parse(insertBankUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bankData),
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'S') {
          return true;
        } else {
          throw Exception('Failed to add stock: ${decodedResponse['message']}');
        }
      } else {
        throw Exception('Failed to add stock');
      }
  }

     Future<bool> insertUser(Map<String, dynamic> userData) async{
      final response = await http.post(
        Uri.parse(insertUserurl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'S') {
          return true;
        } else {
          throw Exception('Failed to add stock: ${decodedResponse['message']}');
        }
      } else {
        throw Exception('Failed to add stock');
      }
  }

   Future<List<Map<String, dynamic>>> getTradeAprovel( String AproverData)async{
    final response = await http.get(
      Uri.parse(getTradeAprovalurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ROLE': AproverData ,
      },

    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if(data is Map<String, dynamic> && data['resp'] is List) {
        var clientList = data['resp'] as List;
        return List<Map<String, dynamic>>.from(clientList);
      } else if (data is List) {
        // If the response is already a list, we can use it directly
      } else {
        throw Exception("Unexpected response format");
        
      }
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load client data');
    }
   }


    Future<bool> userAproval(Map<String, dynamic> userApprovalData) async{
      final response = await http.put(
        Uri.parse(userAprovalurl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userApprovalData),
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'S') {
          return true;
        } else {
          throw Exception('Failed to add stock: ${decodedResponse['message']}');
        }
      } else {
        throw Exception('Failed to add stock');
      }
  }
     
  

  
}



void main(List<String> args) {
  AppService appService = AppService();
  appService.getMyTrade({"CLIENTID": "FT00001"});
}
