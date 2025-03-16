import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:show_room/elements/functions.dart';
import 'package:show_room/elements/widgets.dart';
import 'package:show_room/main.dart';

class ViewExpenseScreen extends StatefulWidget {
  const ViewExpenseScreen({super.key});

  @override
  State<ViewExpenseScreen> createState() => _ViewExpenseScreenState();
}

class _ViewExpenseScreenState extends State<ViewExpenseScreen> {
  String? selectedMonth = "All";
  String? selectedDay = "All";
  
  List<String> monthList = ["All", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  List<String> dayList = ["All", ...List.generate(31, (index) => (index + 1).toString())];
  
  @override
  Widget build(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Expense');
    
    return Scaffold(
      backgroundColor: const Color(0xff0b090a),
      
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Divider(color: Colors.white60, height: 0.25),
        ),
        title: const Text("Expense List", style: TextStyle(
          color: Colors.white60,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        )),
        backgroundColor: const Color(0xff0b090a),
        automaticallyImplyLeading: false,
      ),
      
      floatingActionButton: downloadButton("Expense"),
      
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
                  return const Center(child: Text('No Expense record', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
                } else {  
                  Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = map.values.toList();
                  list.sort((a, b) => int.parse(a['Serial Number']).compareTo(int.parse(b['Serial Number'])));
                  
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      String visitDate = list[index]['Date'];
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
                          title: customerListTitle('${list[index]['Serial Number']} : ₹ ${list[index]['Amount']} - ${list[index]['Expense Details']}'),
                          subtitle: customerListSubTitle('${list[index]['Date']} - ${list[index]['Status']}'),
                          
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
                                          expenseUpdate(list[index]["Serial Number"], "Pending");
                                          Navigator.pop(context);
                                          snackbar("Expense Pending", context);
                                        }, icon: Icon(Icons.pending_actions_rounded,color: Colors.white60,size: 30,)),
                                        IconButton(onPressed: () {
                                          expenseUpdate(list[index]["Serial Number"], "Rejected");
                                          Navigator.pop(context);
                                          snackbar("Expense Rejected", context);
                                        }, icon: Icon(Icons.close_rounded,color: Colors.white60,size: 30,)),
                                        IconButton(onPressed: () {
                                          expenseUpdate(list[index]["Serial Number"], "Approved");
                                          Navigator.pop(context);
                                          snackbar("Expense Approved", context);
                                        }, icon: Icon(Icons.check_rounded,color: Colors.white60,size: 30,)),
                                        
                                      ],
                                    ),
                                  ),
                                );
                              }
                            );
                          } : null,
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