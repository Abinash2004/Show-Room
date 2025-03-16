import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:show_room/elements/functions.dart';
import 'package:show_room/elements/widgets.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});
  
  static var serial = "0";

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {

  var date = "Select a Date";
  var amount = TextEditingController();
  var purchase = TextEditingController();

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: ThemeData.dark(),child: child!);
      },
    );
    if (picked != null) {
      setState(() {
        final formattedDate = DateFormat('dd / MM / yyyy').format(picked);
        date = formattedDate;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0b090a),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        title: Text("Add Expense",style: TextStyle(
          color: Colors.white60,
          fontSize: 25,
          fontWeight: FontWeight.w600
        )),
        backgroundColor: Color(0xff0b090a),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {

              bool condition = date == "Select a Date" || amount.text.toString().isEmpty || purchase.text.toString().isEmpty;
              
              if(condition) {
                snackbar("Incomplete Data", context);
                
              } else {
                await saveExpense(AddExpenseScreen.serial, date, amount, purchase, "Pending", context);
              }
            },
            icon: Icon(Icons.upload_rounded, color: Colors.white60, size: 30))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              inputContainer(Text("Serial Number : ${AddExpenseScreen.serial}",style: textStyle())),
              SizedBox(height: 20),

              inputContainer(Row(children: [
                  Text("Date : \t$date",style: textStyle()),
                  IconButton(onPressed: () => _selectDate(context),icon: Icon(Icons.calendar_month, color: Colors.white60,size: 25)),
                ],
              )),
              SizedBox(height: 20),

              textField("Amount", amount, true),
              SizedBox(height: 20),

              textField("Purchase", purchase, false),
              SizedBox(height: 20),
            ]
          )
        )
      )
    );
  }
}