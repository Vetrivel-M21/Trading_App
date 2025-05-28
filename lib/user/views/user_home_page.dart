import 'package:flutter/material.dart';
import 'package:trade_app/service/service.dart';
import 'package:trade_app/service/user_storage.dart';
import 'package:trade_app/user/widgets/shop_dialog_widget.dart';
import 'package:trade_app/user/widgets/stock_card.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  late Map<dynamic, dynamic> userInformation;
  AppService appService = AppService();
  late Future<List<Map<String, dynamic>>> stocks;
  String? client_name;
  int quantity = 0;

  @override
  void initState() {
    super.initState();

    stocks = appService.getStocks();
    // setName();
  }

  void refreshStocks() {
    setState(() {});
    stocks = appService.getStocks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<dynamic, dynamic>) {
      userInformation = args;
    } else {
      userInformation = {'first_name': 'Guest', 'email': 'guest@example.com'};
    }
  }

  // void setName() async {
  //   await UserStorage.saveClientName(userInformation['first_name']);
  // }

  // void getName()async{
  //   client_name = await
  // }

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    setState(() {
      quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      

      child: Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          image: DecorationImage(
            image: AssetImage('background.png'), // Replace with your asset path
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 10),

            FutureBuilder<List>(
              future: stocks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Please wait..."));
                } else if (snapshot.hasData) {
                  var stock = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true, //
                    physics:
                        NeverScrollableScrollPhysics(), // disable nested scrolling
                    itemCount: stock.length,
                    itemBuilder:
                        (context, index) => StockCard(
                          stockName: stock[index]["stock_name"],
                          stockPrice: stock[index]["stock_price"],
                          stockSegment: stock[index]["segment"],
                          icon: Icons.shopping_cart,
                          buyFunc: () {
                            // if (userInformation["kyc_completed"] == true) {
                            print(stock[index]["stock_id"]);
                            if (userInformation['kyc_completed'] == true) {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => ShopDialog(
                                      stockName: stock[index]["stock_name"],
                                      stockSegment: stock[index]["segment"],
                                      stockPrice: stock[index]["stock_price"],
                                      stockId: stock[index]['stock_id'],
                                      tradeType: "Buy",
                                      clientId: userInformation['client_id'],
                                      kycCompleted:
                                          userInformation['kyc_completed'],
                                      availQuantity: 100,
                                      onStockUpdated: refreshStocks,
                                      // stockQuantity: quantity.toString(),
                                      // totalPrice: (quantity * int.parse(stock[index]["stock_price"])).toString(),
                                      // increment: increment,
                                      // decrement: decrement,
                                    ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("KYC is not Approved")),
                              );
                            }
                            // } else {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(content: Text("Please complete KYC to buy stocks.")),
                            //   );
                            // }
                          },
                        ),
                  );
                } else {
                  return Center(child: Text("No Stocks Available"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
