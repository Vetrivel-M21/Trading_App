import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> soldStocks;
  const HistoryPage({super.key, required this.soldStocks});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          widget.soldStocks.isEmpty
              ? Center(child: Text("No history available"))
              : Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListView.builder(
                  itemCount: widget.soldStocks.length,
                  itemBuilder: (context, index) {
                    final stock = widget.soldStocks[index];
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text("Trade ID: ${stock['trade_id']}"),
                            subtitle: Text("Stock ID: ${stock['stock_id']}"),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(stock['trade_date'].toString().substring(0, 10)),
                                Text(
                                  stock['trade_type'],
                                  style: TextStyle(
                                    color: stock['trade_type'] == 'Sell' ? Colors.red : Colors.green,fontSize: 18 ,fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
                          )
                
                        ],
                      ),
                    );
                
                    // ListTile(
                    //   title: Text("Trade ID: ${stock['trade_id']}"),
                    //   subtitle: Text("Stock ID: ${stock['stock_id']}"),
                    // );
                  },
                ),
              ),
    );
  }
}
