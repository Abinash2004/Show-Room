import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:show_room/Screen/Receive/receive_details.dart';
import 'package:show_room/elements/widgets.dart';
import 'package:show_room/main.dart';

class ViewReceiveScreen extends StatefulWidget {
  const ViewReceiveScreen({super.key});

  @override
  State<ViewReceiveScreen> createState() => _ViewReceiveScreenState();
}

class _ViewReceiveScreenState extends State<ViewReceiveScreen> {

  String? month = "All";
  List<String> monthList = ["All", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  
  @override
  Widget build(BuildContext context) {
    
    final databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Receive');
    
    return Scaffold(
      backgroundColor: Color(0xff0b090a),
      
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        
        title: Text("Receive List", style: TextStyle(
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

      floatingActionButton: downloadButton("Receive"),

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
                  return const Center(child: Text('No Receive Record',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)));
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
                          subtitle: customerListSubTitle('₹ ${list[index]['Amount']} - By ${list[index]['Receiver Name']}'),

                          onTap: () {
                            ReceiveDetailScreen.serialNumber = list[index]['Serial Number'];
                            ReceiveDetailScreen.date = list[index]['Date'];
                            ReceiveDetailScreen.amount = list[index]['Amount'];
                            ReceiveDetailScreen.receiveDetails = list[index]['Receive Details'];
                            ReceiveDetailScreen.customerName = list[index]['Customer Name'];
                            ReceiveDetailScreen.receiverName = list[index]['Receiver Name'];
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const ReceiveDetailScreen()));
                          },

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