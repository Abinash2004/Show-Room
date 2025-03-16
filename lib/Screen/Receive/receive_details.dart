import 'package:flutter/material.dart';
import 'package:show_room/elements/widgets.dart';

class ReceiveDetailScreen extends StatefulWidget {
  const ReceiveDetailScreen({super.key});

  static var serialNumber = "";
  static var date = "";
  static var amount = "";
  static var receiveDetails = "";
  static var customerName = "";
  static var receiverName = "";

  @override
  State<ReceiveDetailScreen> createState() => _ReceiveDetailScreenState();
}

class _ReceiveDetailScreenState extends State<ReceiveDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color(0xff0b090a),
      
      appBar: AppBar(
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        
        title: Text("Receive Information", style: TextStyle(
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
            inputContainer(Text("Serial Number : ${ReceiveDetailScreen.serialNumber}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Date : ${ReceiveDetailScreen.date}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Amount : ${ReceiveDetailScreen.amount}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Receiver Details : ${ReceiveDetailScreen.receiveDetails}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Customer Name : ${ReceiveDetailScreen.customerName}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Receiver Name : ${ReceiveDetailScreen.receiverName}",style: textStyle())),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}