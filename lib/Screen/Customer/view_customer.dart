import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:show_room/Screen/Customer/modify_customer.dart';
import 'package:show_room/Screen/Customer/customer_details.dart';
import 'package:show_room/elements/widgets.dart';
import 'package:show_room/main.dart';

class ViewCustomerScreen extends StatefulWidget {
  const ViewCustomerScreen({super.key});

  @override
  State<ViewCustomerScreen> createState() => _ViewCustomerScreenState();
}

class _ViewCustomerScreenState extends State<ViewCustomerScreen> {
  String? selectedMonth = "All";
  String? selectedDay = "All";
  
  List<String> monthList = ["All", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  List<String> dayList = ["All", ...List.generate(31, (index) => (index + 1).toString())];
  
  @override
  Widget build(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Customer');
    
    return Scaffold(
      backgroundColor: const Color(0xff0b090a),
      
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Divider(color: Colors.white60, height: 0.25),
        ),
        title: const Text("Customer List", style: TextStyle(
          color: Colors.white60,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        )),
        backgroundColor: const Color(0xff0b090a),
        automaticallyImplyLeading: false,
      ),
      
      floatingActionButton: downloadButton("Follow Up"),
      
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                appBarInputContainer(DropdownButton<String>(
                  dropdownColor: Color.fromARGB(255, 30, 30, 30),
                  value: selectedDay,
                  items: dayList.map((day) => DropdownMenuItem(
                    value: day,
                    child: Text(day, style: textStyle())
                  )).toList(),
                  onChanged: (value) {
                    setState(() { selectedDay = value; });
                  },
                )),
                appBarInputContainer(DropdownButton<String>(
                  dropdownColor: Color.fromARGB(255, 30, 30, 30),
                  value: selectedMonth,
                  items: monthList.map((month) => DropdownMenuItem(
                    value: month,
                    child: Text(month, style:textStyle())
                  )).toList(),
                  onChanged: (value) {
                    setState(() { selectedMonth = value; });
                  },
                )),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          Expanded(
            child: StreamBuilder(
              stream: databaseRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.data!.snapshot.children.isEmpty) {
                  return const Center(child: Text('No Customer record', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
                } else {  
                  Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = map.values.toList();
                  list.sort((a, b) => int.parse(a['Serial Number']).compareTo(int.parse(b['Serial Number'])));
                  
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      String visitDate = list[index]['Visit Date'];
                      List<String> dateParts = visitDate.split(' / ');
                      String day = dateParts[0];
                      String month = DateFormat('MMM').format(DateTime(0, int.parse(dateParts[1])));
                      
                      bool isExist = (selectedDay == "All" || selectedDay == day) && (selectedMonth == "All" || selectedMonth == month);
                      
                      return isExist ? Card(
                        color: const Color.fromARGB(255, 25, 25, 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ListTile(
                          title: customerListTitle('${list[index]['Serial Number']} : ${list[index]['Customer Name']} - ${list[index]['Contact Number']}'),
                          subtitle: customerListSubTitle('Visited - ${list[index]['Visit Date']} - ${list[index]['Customer Status']}'),
                          
                          onTap: () {
                            CustomerDetailScreen.serialNumber = list[index]['Serial Number'];
                            CustomerDetailScreen.visitDate = list[index]['Visit Date'];
                            CustomerDetailScreen.customerName = list[index]['Customer Name'];
                            CustomerDetailScreen.contactNumber = list[index]['Contact Number'];
                            CustomerDetailScreen.address = list[index]['Address'];
                            CustomerDetailScreen.modelName = list[index]['Model Name'];
                            CustomerDetailScreen.variantName = list[index]['Variant Name'];
                            CustomerDetailScreen.modelColor = list[index]['Model Color'];
                            CustomerDetailScreen.customerStatus = list[index]['Customer Status'];
                            CustomerDetailScreen.paymentType = list[index]['Payment Type'];
                            CustomerDetailScreen.followUpDate = list[index]['Follow Up Date'];
                            CustomerDetailScreen.remark1 = list[index]['Remark 1'];
                            CustomerDetailScreen.remark2 = list[index]['Remark 2'];
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerDetailScreen()));
                          },
                          
                          onLongPress: () {
                            ModifyCustomerScreen.serial = list[index]['Serial Number'];
                            ModifyCustomerScreen.visitDate = list[index]['Visit Date'];
                            ModifyCustomerScreen.customerName.setText(list[index]['Customer Name']);
                            ModifyCustomerScreen.contactNumber.setText(list[index]['Contact Number']);
                            ModifyCustomerScreen.address.setText(list[index]['Address']);
                            ModifyCustomerScreen.modelName.setText(list[index]['Model Name']);
                            ModifyCustomerScreen.variantName.setText(list[index]['Variant Name']);
                            ModifyCustomerScreen.color.setText(list[index]['Model Color']);
                            ModifyCustomerScreen.customerStatus = list[index]['Customer Status'];
                            ModifyCustomerScreen.paymentType = list[index]['Payment Type'];
                            ModifyCustomerScreen.followUpDate = list[index]['Follow Up Date'];
                            ModifyCustomerScreen.remark1.setText(list[index]['Remark 1']);
                            ModifyCustomerScreen.remark2.setText(list[index]['Remark 2']);
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const ModifyCustomerScreen()));
                          },
                        ),
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