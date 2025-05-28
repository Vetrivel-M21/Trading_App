import 'package:flutter/material.dart';

class StockCard extends StatelessWidget {
  final String stockName;
  final String stockSegment;
  final String stockPrice;
  final VoidCallback buyFunc;
  final IconData icon;
  const StockCard({
    super.key,
    required this.stockName,
    required this.stockPrice,
    required this.stockSegment,
    required this.buyFunc,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        color: const Color.fromARGB(186, 255, 255, 255),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 7,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stockName,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " $stockSegment",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\u{20B9} $stockPrice",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        iconColor: Colors.white,
                        iconSize: 30,
                      ),
                      onPressed: buyFunc,
                      child: Icon(icon),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
