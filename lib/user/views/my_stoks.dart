import 'package:flutter/material.dart';
import 'package:trade_app/service/service.dart';
import 'package:trade_app/service/user_storage.dart';
import 'package:trade_app/user/widgets/shop_dialog_widget.dart';
import 'package:trade_app/user/widgets/stock_card.dart';

class MyStoks extends StatefulWidget {
  const MyStoks({super.key});

  @override
  State<MyStoks> createState() => _MyStoksState();
}

class _MyStoksState extends State<MyStoks> {
  late Map<dynamic, dynamic> userInformation;
  AppService appService = AppService();
  late List<Map<String, dynamic>> stocks;
  String? clientID;
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    getStocksData();
   
    // print(stocks);
  }

  void getStocksData() async {
    clientID = await UserStorage.getClientId();
     stocks = await appService.getMyTrade(clientID.toString());
     print(stocks); 
     setState(() {
     
       
     });
  // If you want to store it as a Future later
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<dynamic, dynamic>) {
      userInformation = args;
    } else {
      userInformation = {
        'client_id': 'FT00021',
        'first_name': 'Guest',
        'email': 'guest@example.com',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.blue,
            child: Center(
              child: Text(
                "Welcome ${userInformation['first_name']}",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),

          SizedBox(height: 10),

          
          ListView.builder(
                shrinkWrap: true, //
                physics:
                    NeverScrollableScrollPhysics(), // disable nested scrolling
                itemCount: stocks.length,
                itemBuilder:
                    (context, index) => StockCard(
                      stockName: "Trade ID : ${stocks[index]['trade_id']}",
                      stockPrice: stocks[index]["trade_price"],
                      stockSegment: "Stock ID: ${stocks[index]['stock_id']}",
                      buyFunc: () {
                        if (userInformation["kyc_completed"] == true) {
                          print(stocks[index]["stock_id"]);
                          showDialog(
                            context: context,
                            builder:
                                (context) => ShopDialog(
                                  stockName:"Trade ID : ${stocks[index]['trade_id']}",
                                  stockSegment:" Stock ID: ${stocks[index]['stock_id']} ",
                                  stockPrice: stocks[index]["trade_price"],
                                  stockId: stocks[index]['stock_id'],
                                  tradeType: "Sell",
                                  clientId: userInformation['client_id'],
                                  kycCompleted:
                                      userInformation['kyc_completed'],
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
