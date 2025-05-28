import 'dart:convert';
import 'package:http/http.dart' as http;

class AppService {
  static const String _baseUrl = "http://192.168.2.34:29091";
  final String url = "$_baseUrl/getBankMaster";
  final String registerUrl = '$_baseUrl/clientRegister';
  final String userloginUrl = '$_baseUrl/clientLogin';
  final String adminLoginUrl = '$_baseUrl/adminLogin';
  final String getMyTradeUrl = '$_baseUrl/getTrade';
  final String getClientDataUrl = '$_baseUrl/getClientData';
  final String kycUpdateUrl = '$_baseUrl/kycApprovals';
  final String addStocksUrl = '$_baseUrl/insertStock';
  final String insertBankUrl = '$_baseUrl/insertBank';
  final String insertUserurl = '$_baseUrl/insertUser';
  final String getTradeAprovalurl = '$_baseUrl/getTradeApproval';
  final String userAprovalurl = '$_baseUrl/userApproval';
  final String getStocksurl = '$_baseUrl/getStocks';
  final String buyAndSellStocksurl = '$_baseUrl/buySell';

  late final Map<String, dynamic> responseData;
  // Function to get bank details
  Future<List<Map<String, dynamic>>> getBankDetails() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);

      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse['resp'] is List) {
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
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    print("Calling: $registerUrl");
    print("Payload: ${jsonEncode(userData)}");

    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(userData),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to register user. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to fetch: $e');
    }
  }

  //user login
  Future<http.Response> UserlogIn(Map loginData) async {
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
  Future<List<Map<String, dynamic>>> getMyTrade(String client) async {
    if (client.isEmpty) {
      throw ArgumentError('Client ID cannot be null or empty');
    }
    final response = await http.get(
      Uri.parse(getMyTradeUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'CLIENTID': client,
      },
    );

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);

      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse['resp'] is List) {
        var TradeList = decodedResponse['resp'] as List;
        return List<Map<String, dynamic>>.from(TradeList);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load Trade details');
    }
  }
  // getMyTrade(Map ClientID) async {
  //   final response = await http.get(
  //     Uri.parse(getMyTradeUrl),
  //     headers: <String, String>{'CLIENTID': ClientID.toString()},
  //   );

  //   if (response.statusCode == 200) {
  //     var decodedResponse = jsonDecode(response.body);

  //     print(decodedResponse);
  //   } else {
  //     throw Exception('Failed to load trade details');
  //   }
  // }

  Future<List<Map<String, dynamic>>> getClientData() async {
    final response = await http.get(Uri.parse(getClientDataUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data['resp'] is List) {
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

  Future<bool> addStocks(Map<String, dynamic> stockData) async {
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

  Future<bool> insertBank(Map<String, dynamic> bankData) async {
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

  Future<bool> insertUser(Map<String, dynamic> userData) async {
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

  Future<List<Map<String, dynamic>>> getTradeAprovel(String AproverData) async {
    final response = await http.get(
      Uri.parse(getTradeAprovalurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ROLE': AproverData,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data['resp'] is List) {
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

  Future<bool> userAproval(Map<String, dynamic> userApprovalData) async {
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

  //get Stocks
  Future<List<Map<String, dynamic>>> getStocks() async {
    final response = await http.get(Uri.parse(getStocksurl));

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);

      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse['resp'] is List) {
        var banksList = decodedResponse['resp'] as List;
        return List<Map<String, dynamic>>.from(banksList);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load bank details');
    }
  }

  //buyandSell
  Future<Map<String, dynamic>> buyandSell(
    Map<String, dynamic> purchaseData,
  ) async {
    final response = await http.post(
      Uri.parse(buyAndSellStocksurl),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(purchaseData),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print(responseData);
      return responseData;
    } else {
      throw Exception("Failed to purchase");
    }
  }
}

// Future<void> main(List<String> args) async {
//   AppService appService = AppService();
//   appService.getMyTrade({"CLIENTID": "FT00001"});
//   Map<String, dynamic> respose = await appService.buyandSell({
//     "client_id": "FT00083",
//     "trade_type": "Buy",
//     "quantity": 3,
//     "trade_price": 6801.5,
//     "stock_id": 13,
//     "backOfficer_approve": "pending",
//     "biller_approve": "pending",
//     "approver": "pending",
//     "kyc_completed": true,
//   });

//   print(respose['resp']);
// }
