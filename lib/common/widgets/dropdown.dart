import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {
  final TextEditingController controller;
  final String lable;
  final Future<List> item;
  final Function(String bankId, String ifscCode) onBankSelected;

  const MyDropDown({
    super.key,
    required this.lable,
    required this.item,
    required this.controller,
    required this.onBankSelected
  });

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  bool displayList = false;
  late String BankId;
  late String BankIFSCcode;
   late List<String> bankInfo;


  List<String> BankIdIFSC(String ifsc, String id){
    bankInfo.add(ifsc);
    bankInfo.add(id);
    return bankInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(),
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: widget.lable,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    displayList = !displayList;
                  });
                },
                child: Icon(Icons.arrow_drop_down_rounded),
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // Use FutureBuilder to load the items asynchronously
        displayList
            ? FutureBuilder<List>(
                future: widget.item,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    // If data is available, show the list
                    var items = snapshot.data!;
                    return Container(
                      width: 200,
                      height: 300,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(items[index]["bank_name"] ?? 'No name'),
                          onTap: () {
                            setState(() {
                              widget.controller.text = items[index]["bank_name"];
                              widget.onBankSelected(
                                items[index]["bank_id"].toString(),
                                items[index]["ifsc_code"] ??'',
                              );
                              
                              displayList = false;
                            });
                          },
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              )
            : SizedBox(),
      ],
    );
  }
}
