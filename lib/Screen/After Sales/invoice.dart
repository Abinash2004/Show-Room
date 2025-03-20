import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:show_room/elements/functions.dart';
import 'package:show_room/elements/widgets.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  static var serial = "";
  static var customerName = "";

  @override
  State<InvoiceScreen> createState() => InvoiceScreenState();
}

class InvoiceScreenState extends State<InvoiceScreen> {
  
  var invoiceNumber = TextEditingController();
  var invoiceDate = "Select a Date";

  DateTime? selectedStockDate;

  Future<void> _selectDate(BuildContext context, bool isSold) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: ThemeData.dark(),child: child!);
      },
    );
    if (picked != null && picked != selectedStockDate) {
      setState(() {
        selectedStockDate = DateTime(picked.year, picked.month, picked.day);
        (isSold) ? invoiceDate = DateFormat('dd / MM / yyyy').format(selectedStockDate!) : invoiceDate = DateFormat('dd / MM / yyyy').format(selectedStockDate!);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 10, 10),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        title: Text("Add Invoice", style: TextStyle(
          color: Colors.white60,
          fontSize: 25,
          fontWeight: FontWeight.w600
        )),
        backgroundColor: Color(0xff0b090a),
        automaticallyImplyLeading: false,
        actions: [

          IconButton(
            onPressed: () async {

              bool condition =  invoiceDate == "Select a Date" || invoiceNumber.text.isEmpty ;

              if(condition) {
                snackbar("Incomplete Data", context);
              }
              else {
                await saveInvoice(InvoiceScreen.serial, invoiceNumber, invoiceDate, context);
              }
            },
            icon: Icon(Icons.upload_rounded, color: Colors.white60, size: 30))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Align(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                inputContainer(Text("Customer Name : ${InvoiceScreen.customerName}",style: textStyle())),
                SizedBox(height: 20),

                textField("Invoice Number", invoiceNumber, false),
                SizedBox(height: 20),

                inputContainer(Row( children: [
                    Text("Invoice Date : \t$invoiceDate",style: textStyle()),
                    IconButton(onPressed: () => _selectDate(context,false),icon: Icon(Icons.calendar_month, color: Colors.white60,size: 25)),
                  ],
                )),
                SizedBox(height: 20),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}