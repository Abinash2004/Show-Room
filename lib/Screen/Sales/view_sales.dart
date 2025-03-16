import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:show_room/Screen/Sales/sales_details.dart';
import 'package:show_room/elements/widgets.dart';
import 'package:show_room/main.dart';

class ViewSalesScreen extends StatefulWidget {
  const ViewSalesScreen({super.key});

  @override
  State<ViewSalesScreen> createState() => _ViewSalesScreenState();
}

class _ViewSalesScreenState extends State<ViewSalesScreen> {

  String? month = "All";
  List<String> monthList = ["All", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  
  @override
  Widget build(BuildContext context) {
    
    final databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Stock');
    
    return Scaffold(
      backgroundColor: Color(0xff0b090a),
      
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        
        title: Text("Sales List", style: TextStyle(
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

      floatingActionButton: downloadButton("Sales"),

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
                  return const Center(child: Text('No Sales Record',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)));
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
                      if(month == "All" && list[index]['Stock Status'] != "Stock") {
                        isExist = true;
                      } else if(month == DateFormat.MMM().format(DateFormat("dd / MM / yyyy").parse(list[index]['Stock Date'])) && list[index]['Stock Status'] != "Stock") {
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
                          
                          title: customerListTitle('${list[index]['Serial Number']} : ${list[index]['Model Name']} | ${list[index]['Variant Name']}'),
                          subtitle: customerListSubTitle('${list[index]['Model Color']}'),

                          onTap: () {
                            SalesDetailScreen.serialNumber = list[index]['Serial Number'];
                            SalesDetailScreen.stockDate = list[index]['Stock Date'];
                            SalesDetailScreen.import = list[index]['Import Method'];
                            SalesDetailScreen.chassis = list[index]['Chassis Number'];
                            SalesDetailScreen.modelName = list[index]['Model Name'];
                            SalesDetailScreen.variantName = list[index]['Variant Name'];
                            SalesDetailScreen.modelColor = list[index]['Model Color'];
                            SalesDetailScreen.exShowRoom = list[index]['Ex-Showroom Amount'];
                            SalesDetailScreen.insurance = list[index]['Insurance Amount'];
                            SalesDetailScreen.rto = list[index]['RTO Amount'];
                            SalesDetailScreen.hp = list[index]['HP Amount'];
                            SalesDetailScreen.proPack = list[index]['Pro Pack Amount'];
                            SalesDetailScreen.total = list[index]['Total Amount'];
                            SalesDetailScreen.stockStatus = list[index]['Stock Status'];
                            SalesDetailScreen.salesDate = list[index]['Sales Date'];
                            SalesDetailScreen.paymentType = list[index]['Payment Type'];
                            SalesDetailScreen.disAmount = list[index]['Dis Amount'];
                            SalesDetailScreen.customerName = list[index]['Customer Name'];
                            SalesDetailScreen.downPayment = list[index]['Down Payment'];
                            SalesDetailScreen.receivedAmount = list[index]['Received Amount'];
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const SalesDetailScreen()));
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