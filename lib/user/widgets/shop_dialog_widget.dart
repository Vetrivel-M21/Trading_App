import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_app/service/service.dart';

class ShopDialog extends StatefulWidget {
  final String stockName;
  final String stockSegment;
  final String stockPrice;
  final String clientId;
  final String tradeType;
  final int stockId;
  final bool kycCompleted;
  final int availQuantity;
  final VoidCallback onStockUpdated;

  const ShopDialog({
    super.key,
    required this.stockName,
    required this.stockSegment,
    required this.stockPrice,
    required this.clientId,
    required this.tradeType,
    required this.stockId,
    required this.kycCompleted,
    required this.availQuantity,
    required this.onStockUpdated
  });

  @override
  State<ShopDialog> createState() => _ShopDialogState();
}

class _ShopDialogState extends State<ShopDialog> {
  int quantity = 0;
  late Future<Map<String, dynamic>> respose;
  AppService appService = AppService();

  void buySell() async {
    if (quantity > 0) {
      Map<String, dynamic> buyOrSellStock = {
        "client_id": widget.clientId,
        "trade_type": widget.tradeType,
        "quantity": quantity,
        "trade_price": double.parse(widget.stockPrice),
        "stock_id": widget.stockId,
        "backOfficer_approve": "pending",
        "biller_approve": "pending",
        "approver": "pending",
        "kyc_completed": widget.kycCompleted,
      };

      appService
          .buyandSell(buyOrSellStock)
          .then((response) {
            if (response['status'] == 'S') {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(
                content: Text(response['resp']),
                backgroundColor: Colors.green,
              ));
              widget.onStockUpdated(); 
              // Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response['resp']),
                  backgroundColor: Colors.red,
                ),
              );
            }
            Navigator.pop(context);
          })
          .catchError((error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Erorr:::$error")));
          });

          
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = quantity * double.parse(widget.stockPrice);
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.stockName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.stockSegment,
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.inactiveGray,
              ),
            ),
            Text(
              "\u{20B9} ${widget.stockPrice}",
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quantity: $quantity"),
                Row(
                  children: [
                    IconButton(
                      onPressed:
                          () => setState(() => quantity > 0 ? quantity-- : 0),
                      icon: Icon(Icons.remove, color: Colors.orangeAccent),
                    ),
                    Text("$quantity"),
                    IconButton(
                      onPressed:
                          () => setState(
                            () =>
                                quantity < widget.availQuantity
                                    ? quantity++
                                    : quantity,
                          ),
                      icon: Icon(Icons.add, color: Colors.greenAccent),
                    ),
                  ],
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ₹${totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(onPressed: buySell, child: Text(widget.tradeType)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
