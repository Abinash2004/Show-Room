import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:show_room/Screen/Stock/stock_details.dart';
import 'package:show_room/elements/widgets.dart';
import 'package:show_room/main.dart';

class ViewStockScreen extends StatefulWidget {
  const ViewStockScreen({super.key});

  @override
  State<ViewStockScreen> createState() => _ViewStockScreenState();
}

class _ViewStockScreenState extends State<ViewStockScreen> {

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
        
        title: Text("Stock List", style: TextStyle(
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

      floatingActionButton: downloadButton("Stock"),

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
                  return const Center(child: Text('No Stock Record',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)));
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
                      if(month == "All" && list[index]['Stock Status'] == "Stock") {
                        isExist = true;
                      } else if(month == DateFormat.MMM().format(DateFormat("dd / MM / yyyy").parse(list[index]['Stock Date'])) && list[index]['Stock Status'] == "Stock") {
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
                            StockDetailScreen.serialNumber = list[index]['Serial Number'];
                            StockDetailScreen.stockDate = list[index]['Stock Date'];
                            StockDetailScreen.import = list[index]['Import Method'];
                            StockDetailScreen.chassis = list[index]['Chassis Number'];
                            StockDetailScreen.modelName = list[index]['Model Name'];
                            StockDetailScreen.variantName = list[index]['Variant Name'];
                            StockDetailScreen.modelColor = list[index]['Model Color'];
                            StockDetailScreen.exShowRoom = list[index]['Ex-Showroom Amount'];
                            StockDetailScreen.insurance = list[index]['Insurance Amount'];
                            StockDetailScreen.rto = list[index]['RTO Amount'];
                            StockDetailScreen.hp = list[index]['HP Amount'];
                            StockDetailScreen.proPack = list[index]['Pro Pack Amount'];
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const StockDetailScreen()));
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