import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trade_app/common/widgets/my_card.dart';
import 'package:trade_app/service/service.dart';

class ClientsApprovalPage extends StatefulWidget {
  const ClientsApprovalPage({super.key});

  @override
  State<ClientsApprovalPage> createState() => _ClientsApprovalPageState();
}

class _ClientsApprovalPageState extends State<ClientsApprovalPage> {
  late Future<List<Map<String, dynamic>>> clientsData;
  AppService appService = AppService();

  @override
  void initState() {
    super.initState();
    clientsData = appService.getClientData();
    print(clientsData);
    // Initialize any data or state here if needed
  }

  
  
  
  void approveClient(Map<String, dynamic> client) {
    Map<String, dynamic> kycData = {
      'client_id': client['client_id'],
      'kyc_completed': true,
    };
    appService.kycUpdate(kycData).then((response) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Client ${client['client_id']} approved successfully')),
        );
        setState(() {
          // Refresh the clients data after approval
          clientsData = appService.getClientData();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to approve client ${client['client_id']}')),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving client: $error')),
      );
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Client Approval"),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: clientsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No clients to approve.'));
          } else {
            final clients = snapshot.data!;
            return ListView.builder(
              
              itemCount: clients.length,
              itemBuilder: (context, index) {
                
                final client =  clients[index];
                // print(client);
                if (client.isEmpty) {
                  return const SizedBox.shrink(); // Skip approved clients
                }
                else{

                return MyCard(
                  clientId:client['client_id'],
                  clientName:" ${client['first_name']}  ${client['last_name']}",
                  kycStatus: client['kyc_completed'] ? 'Approved' : 'Pending',
                  isAprove: (){
                    print("isAprove");
                   
                    approveClient(client);
                  },
                  isNotAprove:(){

                  }
                  
                );
                }
              },
            );
          }
        },
      ),

       
    );
  }
}