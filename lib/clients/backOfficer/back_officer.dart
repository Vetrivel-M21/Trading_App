import 'package:flutter/material.dart';
import 'package:trade_app/service/user_storage.dart';

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
  String? userName;

  late Map<dynamic, dynamic> userInformation;
  // This method is used to get the user information from the previous page

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<dynamic, dynamic>) {
      userInformation = args;
    } else {
      userInformation = {'user': 'Guest'};
    }
    print("client  $userInformation");

    if (userInformation['user'] == "Biller") {
      approver = "biller_approve";
    } else if (userInformation['user'] == "BackOfficer") {
      approver = "backOfficer_approve";
      // print("Approver in method :::::::::::::::::: $approver");
    } else if (userInformation['user'] == "Approver") {
      approver = "approver";
      // print("Approver in method :::::::::::::::::: $approver");
    } else {
      approver = "backOfficer_approve";
    }
    clientsData = appService.getTradeAprovel(userInformation['user']);
    print("Approver in method :::::::::::::::::: $approver");
    print(" Client :::::: $clientsData");
    getUserName();
  }

  void getUserName() async {
    await UserStorage.saveUserName(userInformation['user']);
    userName = await UserStorage.getUserName();
    print("UserName ::::::$userName");
  }

  void approveClient(Map<String, dynamic> client) {
    Map<String, dynamic> userAprovalData = {
      "user": "${userInformation['user']}",
      "trade_id": client["trade_id"],
      "approval": "Approved",
    };
    appService
        .userAproval(userAprovalData)
        .then((response) async {
          if (response) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Client ${client['client_id']} approved successfully',
                ),
              ),
            );
            setState(() {
              // Refresh the clients data after approval
              clientsData = appService.getTradeAprovel(userInformation['user']);
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to approve client ${client['client_id']}',
                ),
              ),
            );
          }
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error approving client: $error')),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${userInformation['user']} Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                ' ${userInformation['user'] ?? 'User'}',
                style: const TextStyle(color: Colors.white, fontSize: 24),
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
      body: FutureBuilder<List>(
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
                final client = clients[index];
                // print("Future Builder ::::::::::: $client");
                // print(client['client_id']);
                // print("Approver :::::::::::::::::: ${client[approver.toString()]} ");
                if (client.isEmpty) {
                  return const SizedBox.shrink(); // Skip approved clients
                } else {
                  return MyCard(
                    clientId:
                        "${client['client_id']}  ${client['tradeClient']['first_name']}",
                    clientName:
                        " ${client['tradeStocks']['stock_name']}  quantity: ${client['quantity']}",

                    kycStatus: client[approver],

                    isAprove: () {
                      print("isAprove");

                      approveClient(client);
                    },
                    isNotAprove: () {},
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
