import 'package:flutter/material.dart';
import 'package:trade_app/common/widgets/dropdown.dart';
import 'package:trade_app/common/widgets/my_dialuge.dart';
import 'package:trade_app/common/widgets/text_field.dart';
import 'package:trade_app/service/service.dart';

import 'views/client_approval.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController stockNameController = TextEditingController();
  final TextEditingController stockPriceController = TextEditingController();
  final TextEditingController segmentController = TextEditingController();
  final TextEditingController isinController = TextEditingController();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  final TextEditingController userRollController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  final TextEditingController brokeragechargeTypeController =
      TextEditingController();
  final TextEditingController brokerageeffectiveDateController =
      TextEditingController();
  final TextEditingController brokerageChargeController =
      TextEditingController();

  final List<String> userRolls = ["Back Office", "Biller", "Approver"];
  final List<String> userStatus = ["Active", "Inactive"];

  String selectedUserRoll = "Back Office";
  String selectedUserStatus = "Active";

  void onChanged(String? value) {
    setState(() {
      selectedUserRoll = value ?? "Back Office";
      print(value);
    });
  }

  late Map<dynamic, dynamic> userInformation;
  // This method is used to get the user information from the previous page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<dynamic, dynamic>) {
      userInformation = args;
    } else {
      userInformation = {'user_name': 'Guest'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> addUserFormKey = GlobalKey<FormState>();
    AppService appService = AppService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
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
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                userInformation['user_name'] ?? 'Admin',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Navigator.pushNamed(context, '/Adminprofile', arguments: userInformation);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Welcome to Admin Page",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Manage Users, Stocks",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],

                  //add Stocks , add users, add banks, cliend Approval,
                ),
              ),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("Add Banks")),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => MyDialuge(
                                    lable1: "Bank Name",
                                    lable2: "Branch Name",
                                    lable3: "IFSC Code",
                                    lable4: "Address",
                                    lable1Controller: bankNameController,
                                    lable2Controller: branchNameController,
                                    lable3Controller: ifscCodeController,
                                    lable4Controller: addressController,
                                    lable1Validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter Bank Name";
                                      }
                                      return null;
                                    },
                                    lable2Validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter Branch Name";
                                      }
                                      return null;
                                    },
                                    lable3Validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter IFSC Code";
                                      } else if (RegExp(
                                            "^[A-Z]{4}0[A-Z0-9]{6}\$",
                                          ).hasMatch(value) ==
                                          false) {
                                        return "Please enter a valid IFSC code";
                                      }
                                      return null;
                                    },
                                    lable4Validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter the Address";
                                      }
                                      return null;
                                    },
                                    onSubmit: () {
                                      Map<String, dynamic> bankData = {
                                        'bank_name': bankNameController.text,
                                        'branch_name':
                                            branchNameController.text,
                                        'ifsc_code': ifscCodeController.text,
                                        'address': addressController.text,
                                      };

                                      appService
                                          .insertBank(bankData)
                                          .then((value) {
                                            if (value) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Bank added successfully',
                                                  ),
                                                ),
                                              );
                                              bankNameController.clear();
                                              branchNameController.clear();
                                              ifscCodeController.clear();
                                              addressController.clear();
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Failed to add bank',
                                                  ),
                                                ),
                                              );
                                            }
                                          })
                                          .catchError((error) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text('Error: $error'),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                            );
                          },
                          child: Text("Add Bank"),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("Add Stocks")),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => MyDialuge(
                                    lable1: "Stock Name",
                                    lable2: "Stock Price",
                                    lable3: "Segment",
                                    lable4: "ISIN",
                                    lable1Controller: stockNameController,
                                    lable2Controller: stockPriceController,
                                    lable3Controller: segmentController,
                                    lable4Controller: isinController,
                                    lable1Validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter Stock Name";
                                      }
                                      return null;
                                    },
                                    lable2Validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter Stock Price";
                                      } else if (RegExp(
                                            "^[0-9]",
                                          ).hasMatch(value) ==
                                          false) {
                                        return "Please enter a valid Stock Price";
                                      }
                                      return null;
                                    },
                                    lable3Validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter Segment";
                                      }
                                      return null;
                                    },
                                    lable4Validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter the ISIN";
                                      }
                                      return null;
                                    },
                                    onSubmit: () {
                                      Map<String, dynamic> stockData = {
                                        'stock_name': stockNameController.text,
                                        'stock_price': int.parse(
                                          stockPriceController.text,
                                        ),
                                        'segment': segmentController.text,
                                        'isin': isinController.text,
                                      };

                                      appService
                                          .addStocks(stockData)
                                          .then((value) {
                                            if (value) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Stock added successfully',
                                                  ),
                                                ),
                                              );
                                              stockNameController.clear();
                                              stockPriceController.clear();
                                              segmentController.clear();
                                              isinController.clear();
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Failed to add stock',
                                                  ),
                                                ),
                                              );
                                            }
                                          })
                                          .catchError((error) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text('Error: $error'),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                            );
                          },
                          child: Text("Add Stocks"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("Client Approval")),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const ClientsApprovalPage(),
                              ),
                            );
                          },
                          child: Text("Approve Clients"),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("Add Brokarage")),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text("Add Brokarage"),
                                    content: Form(
                                      child: Column(
                                        children: [
                                          MyTextFeild(
                                            controller:
                                                brokeragechargeTypeController,
                                            lable: "Brokerage Charge Type",
                                            readOnly: false,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter Brokerage Charge Type";
                                              }
                                              return null;
                                            },
                                          ),
                                          MyTextFeild(
                                            controller:
                                                brokeragechargeTypeController,
                                            lable: "",
                                            readOnly: false,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter Brokerage Charge Type";
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            );
                          },
                          child: Text("Add Brokarage"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("Add Users")),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text("Add User"),
                              content: StatefulBuilder(
                                builder:
                                    (context, setState) => Form(
                                      key: addUserFormKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          MyTextFeild(
                                            controller: userNameController,
                                            lable: "User Name",
                                            readOnly: false,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter User Name";
                                              }
                                              return null;
                                            },
                                          ),
                                          MyTextFeild(
                                            controller: userPasswordController,
                                            lable: "User Password",
                                            readOnly: false,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter User Password";
                                              }
                                              return null;
                                            },
                                          ),
                                          DropdownButton<String>(
                                            value: selectedUserRoll,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedUserRoll = newValue!;
                                              });
                                            },
                                            items:
                                                userRolls.map<
                                                  DropdownMenuItem<String>
                                                >((String role) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: role,
                                                    child: Text(role),
                                                  );
                                                }).toList(),
                                            isExpanded: true,
                                            hint: Text("Select User Role"),
                                            underline: Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ),

                                          DropdownButton<String>(
                                            value: selectedUserStatus,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedUserStatus = newValue!;
                                              });
                                            },
                                            items:
                                                userStatus.map<
                                                  DropdownMenuItem<String>
                                                >((String status) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: status,
                                                    child: Text(status),
                                                  );
                                                }).toList(),
                                            isExpanded: true,
                                            hint: Text("Select User Role"),
                                            underline: Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (addUserFormKey.currentState!
                                        .validate()) {
                                      // Handle the form submission
                                      // You can add the user to your database or perform any other action
                                      // print("User Name: ${userNameController.text}");
                                      // print("User Password: ${userPasswordController.text}");
                                      // print("User Role: $selectedUserRoll");
                                      // print("User Status: $selectedUserStatus");

                                      Map<String, dynamic> userData = {
                                        "user_name": userNameController.text,
                                        "password": userPasswordController.text,
                                        "role": selectedUserRoll,
                                        "status": selectedUserStatus,
                                      };

                                      appService
                                          .insertUser(userData)
                                          .then((value) {
                                            if (value) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'User added successfully',
                                                  ),
                                                ),
                                              );
                                              userNameController.clear();
                                              userPasswordController.clear();
                                              userRollController.clear();
                                              statusController.clear();
                                              Navigator.of(context).pop();
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Failed to add user',
                                                  ),
                                                ),
                                              );
                                            }
                                          })
                                          .catchError((error) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text('Error: $error'),
                                              ),
                                            );
                                          });

                                      // Navigator.of(context).pop();
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please fill all fields correctly',
                                          ),
                                        ),
                                      );
                                    }

                                    // Navigator.of(context).pop();
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                      );
                    },
                    child: Text("Add Users"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
