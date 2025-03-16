import 'package:flutter/material.dart';
import 'package:show_room/elements/widgets.dart';

class DepositeDetailScreen extends StatefulWidget {
  const DepositeDetailScreen({super.key});

  static var serialNumber = "";
  static var date = "";
  static var customer = "";
  static var amount = "";
  static var accNumber = "";
  static var bank = "";
  static var depositor = "";

  @override
  State<DepositeDetailScreen> createState() => _DepositeDetailScreenState();
}

class _DepositeDetailScreenState extends State<DepositeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color(0xff0b090a),
      
      appBar: AppBar(
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        
        title: Text("Deposit Information", style: TextStyle(
          color: Colors.white60,
          fontSize: 25,
          fontWeight: FontWeight.w600
        )),
        
        backgroundColor: Color(0xff0b090a),
        automaticallyImplyLeading: false,

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            inputContainer(Text("Serial Number : ${DepositeDetailScreen.serialNumber}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Date : ${DepositeDetailScreen.date}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Customer : ${DepositeDetailScreen.customer}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Amount : ${DepositeDetailScreen.amount}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Account Number : ${DepositeDetailScreen.accNumber}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Bank : ${DepositeDetailScreen.bank}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Depositor : ${DepositeDetailScreen.depositor}",style: textStyle())),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}