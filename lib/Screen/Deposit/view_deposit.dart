import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:show_room/Screen/Deposit/deposit_details.dart';
import 'package:show_room/elements/functions.dart';
import 'package:show_room/elements/widgets.dart';
import 'package:show_room/main.dart';

class ViewDepositScreen extends StatefulWidget {
  const ViewDepositScreen({super.key});

  @override
  State<ViewDepositScreen> createState() => _ViewDepositScreenState();
}

class _ViewDepositScreenState extends State<ViewDepositScreen> {

  String? month = "All";
  List<String> monthList = ["All", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  
  @override
  Widget build(BuildContext context) {
    
    final databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Deposit');
    
    return Scaffold(
      backgroundColor: Color(0xff0b090a),
      
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        
        title: Text("Deposit List", style: TextStyle(
          color: Colors.white60,
          fontSize: 25,
          fontWeight: FontWeight.w600
        )),
        
        backgroundColor: Color(0xff0b090a),
        automaticallyImplyLeading: false,

        actions: [
          appBarInputContainer(DropdownButton<String>(
            dropdownColor: Color.fromARGB(255, 30, 30, 30),
            value: month,
            items: monthList.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: textStyle()),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {month = newValue;});
            },
          )),
        ],
      ),

      floatingActionButton: downloadButton("Deposit"),

      body: Column(
        children: [

          Expanded(
            child: StreamBuilder(
              stream:databaseRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if (snapshot.data!.snapshot.children.isEmpty) {
                  return const Center(child: Text('No Deposit Record',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)));
                }
                else {  
                  Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();
                  list.sort((a, b) => int.parse(a['Serial Number']).compareTo(int.parse(b['Serial Number'])));

                  return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context,index) {
                      bool isExist = true;
                      if(month == "All") {
                        isExist = true;
                      } else if(month == DateFormat.MMM().format(DateFormat("dd / MM / yyyy").parse(list[index]['Date']))) {
                        isExist = true;
                      } else {
                        isExist = false;
                      }
                      return isExist ? Card(
                        color: Color.fromARGB(255, 25, 25, 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ListTile(
                          
                          title: customerListTitle('${list[index]['Serial Number']} - ${list[index]['Customer Name']} - ${list[index]['Date']}'),
                          subtitle: customerListSubTitle('₹ ${list[index]['Amount']} - By ${list[index]['Depositor']} - ${list[index]['Status']}'),

                          onTap: () {
                            DepositeDetailScreen.serialNumber = list[index]['Serial Number'];
                            DepositeDetailScreen.date = list[index]['Date'];
                            DepositeDetailScreen.amount = list[index]['Amount'];
                            DepositeDetailScreen.customer = list[index]['Customer Name'];
                            DepositeDetailScreen.accNumber = list[index]['Account Number'];
                            DepositeDetailScreen.bank = list[index]['Bank'];
                            DepositeDetailScreen.depositor = list[index]['Depositor'];
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const DepositeDetailScreen()));
                          },

                          onLongPress: (MyApp.user == "Admin") ? () {
                            showModalBottomSheet(
                            context: context,
                            backgroundColor: accentColor,
                            builder: (BuildContext context) {
                              return Container(
                                width: double.infinity,
                                height: 100,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only( 
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(onPressed: () {
                                          depositUpdate(list[index]["Serial Number"], "Not Verified");
                                          Navigator.pop(context);
                                          snackbar("Receive Not Approved", context);
                                        }, icon: Icon(Icons.close_rounded,color: Colors.white60,size: 30,)),
                                        IconButton(onPressed: () {
                                          depositUpdate(list[index]["Serial Number"], "Verified");
                                          Navigator.pop(context);
                                          snackbar("Receive Approved", context);
                                        }, icon: Icon(Icons.check_rounded,color: Colors.white60,size: 30,)),
                                        
                                      ],
                                    ),
                                  ),
                                );
                              }
                            );
                          } : null,
                          
                        ),
                      // ignore: dead_code
                      ) : const SizedBox();
                    }
                  );
                }
              }
            )
          )
        ],
      )
    );
  }
}