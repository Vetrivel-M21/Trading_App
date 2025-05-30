import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trade_app/service/service.dart';
import 'package:trade_app/service/user_storage.dart';
import 'package:trade_app/user/widgets/shop_dialog_widget.dart';
import 'package:trade_app/user/widgets/stock_card.dart';

class MyStoks extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onSoldStocksChanged;
  const MyStoks({super.key, required this.onSoldStocksChanged});

  @override
  State<MyStoks> createState() => _MyStoksState();
}

class _MyStoksState extends State<MyStoks> {
  late Future<List<Map<String, dynamic>>> allStocks;
  // late Map<dynamic, dynamic> userInformation;
  String? client_name;
  bool isUserDataLoaded = false;

  Map<dynamic, dynamic>? userData;
  AppService appService = AppService();
  List<Map<String, dynamic>> stocks = [];
  List<Map<String, dynamic>> soldStocks = [];
  List<Map<String, dynamic>> AllStocks = [];
  String? clientID;
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    allStocks = appService.getStocks();
    allStocks.then((stocks) {
      AllStocks = stocks;
    });
    getStocksData();
    getUserData();
    // print(stocks);
  }

  void getUserData() async {
    String? client_id = await UserStorage.getClientId();
    String? client_pass = await UserStorage.getClientPass();
    Map<String, dynamic> loginData = {
      'client_id': client_id.toString(),
      'password': client_pass.toString(),
    };

    appService.UserlogIn(loginData)
        .then((response) async {
          if (jsonDecode(response.body)['status'] == 'S') {
            final decodedResponse = jsonDecode(response.body);
            if (decodedResponse is Map<String, dynamic> &&
                decodedResponse['resp'] is Map) {
              var userMap = decodedResponse['resp'] as Map;
              setState(() {
                userData = userMap;
                isUserDataLoaded = true;
              });
              // print(UserInfomation);
            }
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Data losed")));
          }
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("An error occurred: $error")));
        });
  }

  void refreshStocks() async {
    clientID = await UserStorage.getClientId();
    List<Map<String, dynamic>> allStocks = await appService.getMyTrade(
      clientID.toString(),
    );

    List<Map<String, dynamic>> available = [];
    List<Map<String, dynamic>> sold = [];

    for (var stock in allStocks) {
      double price = double.parse(stock['trade_price']);
      if (price == 0) {
        sold.add(stock);
      } else {
        available.add(stock);
      }
    }

    setState(() {
      stocks = available;
      soldStocks = sold;
    });
    widget.onSoldStocksChanged(soldStocks);
  }

  void getStocksData() async {
    clientID = await UserStorage.getClientId();
    print("Client ID: $clientID");

    List<Map<String, dynamic>> allStocks = await appService.getMyTrade(
      clientID.toString(),
    );

    List<Map<String, dynamic>> available = [];
    List<Map<String, dynamic>> sold = [];

    for (var stock in allStocks) {
      double price = double.parse(stock['trade_price']);
      // print(price);
      if (price == 0) {
        sold.add(stock);
        // print(stock['trade_price']);
      } else {
        available.add(stock);
      }
    }

    setState(() {
      stocks = available;
      soldStocks = sold;
    });
    print("Available ::::::::::::::$available");
    print("SoldStocks ::::::::::::::$sold");
    widget.onSoldStocksChanged(soldStocks);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final args = ModalRoute.of(context)?.settings.arguments;
  //   if (args != null && args is Map<dynamic, dynamic>) {
  //     userInformation = args;
  //   } else {
  //     userInformation = {
  //       // 'client_id': 'FT00021',
  //       'first_name': 'Guest',
  //       'email': 'guest@example.com',
  //     };
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Container(
          //   height: 200,
          //   color: Colors.blue,
          //   child: Center(
          //     child: Text(
          //       " ${userInformation['first_name']}",
          //       style: TextStyle(color: Colors.white, fontSize: 24),
          //     ),
          //   ),
          // ),
          SizedBox(height: 10),

          stocks.isEmpty
              ? Center(child: Text("No Stack Availbe"))
              : ListView.builder(
                shrinkWrap: true, //
                physics:
                    NeverScrollableScrollPhysics(), // disable nested scrolling
                itemCount: stocks.length,
                itemBuilder:
                    (context, index) => StockCard(
                      stockName:
                          AllStocks.firstWhere(
                            (element) =>
                                element['stock_id'] ==
                                stocks[index]['stock_id'],
                            orElse: () => {'stock_name': 'Unknown'},
                          )['stock_name'],
                      stockPrice: stocks[index]["trade_price"],
                      stockSegment: "Stock ID: ${stocks[index]['stock_id']}",
                      
                      icon: Icons.sell,
                      buyFunc: () {
                        // if (userInformation["kyc_completed"] == true) {
                            if (!isUserDataLoaded) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("User data not loaded yet"),
                                ),
                              );
                              return;
                            }
                        if (userData!["kyc_completed"] == true &&
                            userData!['first_name'] != 'Guest') {
                          // print(userInformation["kyc_completed"]);
                          showDialog(
                            context: context,
                            builder:
                                (context) => ShopDialog(
                                  stockName:
                                      AllStocks.firstWhere(
                                        (element) =>
                                            element['stock_id'] ==
                                            stocks[index]['stock_id'],
                                        orElse: () => {'stock_name': 'Unknown'},
                                      )['stock_name'],
                                  stockSegment:
                                      " Stock ID: ${stocks[index]['stock_id']} ,                          Available quantity : ${stocks[index]['quantity']}",
                                  stockPrice: stocks[index]["trade_price"],
                                  stockId: stocks[index]['stock_id'],
                                  tradeType: "Sell",
                                  clientId: userData!['client_id'],
                                  kycCompleted:
                                      userData!['kyc_completed'],
                                  availQuantity: stocks[index]['quantity'],
                                  onStockUpdated: refreshStocks,
                                  // stockQuantity: quantity.toString(),
                                  // totalPrice: (quantity * int.parse(stock[index]["stock_price"])).toString(),
                                  // increment: increment,
                                  // decrement: decrement,
                                ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please complete KYC to buy stocks.",
                              ),
                            ),
                          );
                        }
                      },
                    ),
              ),
        ],
      ),
    );
  }
}
