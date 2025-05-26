import 'package:flutter/material.dart';

import '../../common/widgets/my_card.dart' show MyCard;
import '../../service/service.dart' show AppService;

class BackOfficer extends StatefulWidget {
  const BackOfficer({super.key});

  @override
  State<BackOfficer> createState() => _BackOfficerState();
}

class _BackOfficerState extends State<BackOfficer> {

  late Future<List<Map<String, dynamic>>> clientsData;
  final AppService appService = AppService();
  late String approver;

  
  
  late Map<dynamic, dynamic> userInformation;
  // This method is used to get the user information from the previous page
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<dynamic, dynamic>) {
      userInformation = args;
    } else {
      userInformation = {
        'user': 'Guest',
      };
    }
    print(userInformation);
   
    if(userInformation['user'] == "Approver") {
      approver = userInformation['user'];
    } else if(userInformation['user'] != "Approver" && userInformation['user'] != null) {
      approver = "${userInformation['user']}_Officer";
    }
    clientsData = appService.getTradeAprovel(userInformation['user']);
  }

  void approveClient(Map<String, dynamic> client) {
    Map<String, dynamic> userAprovalData = {
      "user": "${userInformation['user']}",
      "trade_id": client["trade_id"],
      "approval": "Approved",
    };
    appService.userAproval(userAprovalData).then((response) async {
      if (response) {
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
        title: const Text('Back Officer Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Hello, ${userInformation['user_id'] ?? 'User'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body:  FutureBuilder<List<Map<String, dynamic>>>(
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
                print(client);
                if (client.isEmpty) {
                  return const SizedBox.shrink(); // Skip approved clients
                }
                else{

                return MyCard(
                  clientId:client['client_id'],
                  clientName:" ${client['first_name']}  ${client['last_name']}",
                   
                  kycStatus:  client[approver] ,
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