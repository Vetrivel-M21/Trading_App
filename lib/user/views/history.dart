import 'package:flutter/material.dart';
import 'package:trade_app/service/service.dart';

class HistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> soldStocks;
  const HistoryPage({super.key, required this.soldStocks});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> stocks;
   List<Map<String, dynamic>> AllStocks = [];
  AppService appService = AppService();
  @override
  void initState() {
    super.initState();
    stocks = appService.getStocks();
    stocks.then((stocks) {
      AllStocks = stocks;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: widget.soldStocks.isEmpty
        ? Center(child: Text("No history available"))
        : FutureBuilder<List<Map<String, dynamic>>>(
            future: stocks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading stock data"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No stock data available"));
              }

              final allStocks = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListView.builder(
                  itemCount: widget.soldStocks.length,
                  itemBuilder: (context, index) {
                    final stock = widget.soldStocks[index];
                    final stockName = allStocks.firstWhere(
                      (element) => element['stock_id'] == stock['stock_id'],
                      orElse: () => {'stock_name': 'Unknown'},
                    )['stock_name'];

                    return Card(
                      child: ListTile(
                        title: Text(stockName),
                        subtitle: Text("Stock ID: ${stock['stock_id']}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              stock['trade_date']
                                  .toString()
                                  .substring(0, 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
  );
}

}
