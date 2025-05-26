import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String clientId;
  final String clientName;
  final String kycStatus;
  final VoidCallback isAprove;
  final VoidCallback isNotAprove;
  const MyCard({
    super.key,
    required this.clientId,
    required this.clientName,
    required this.kycStatus,
    required this.isAprove,
    required this.isNotAprove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      color: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          clientId,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          clientName,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
                        ),
                        Text(
                          kycStatus,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 0, 0)),
                        ),
                      ],
                    ),
              ),
          ),
              
            
          
         
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                      ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue, // Text color
                                  ),
                
                                onPressed: isAprove, 
                              child: Text("Approve", 
                                style: TextStyle(fontSize: 14) 
                                ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 212, 210, 210), backgroundColor: const Color.fromARGB(255, 243, 58, 33), // Text color
                          ),
                
                        onPressed: isNotAprove, 
                        child: Text("Reject", 
                          style: TextStyle(fontSize: 14) 
                          ),
                      )
                  ],
                ),
              ),
          ),
          
        
        ],
      )
      
    );
  }
}