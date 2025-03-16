import 'package:flutter/material.dart';
import 'package:show_room/elements/widgets.dart';

class SalesDetailScreen extends StatefulWidget {
  const SalesDetailScreen({super.key});

  static var serialNumber = "";
  static var stockDate = "";
  static var import = "";
  static var chassis = "";
  static var modelName = "";
  static var variantName = "";
  static var modelColor = "";
  static var exShowRoom = "";
  static var insurance = "";
  static var rto = "";
  static var hp = "";
  static var proPack = "";
  static var total = "";
  static var stockStatus = "";
  static var salesDate = "";
  static var paymentType = "";
  static var disAmount = "";
  static var customerName = "";
  static var downPayment = "";
  static var receivedAmount = "";
  


  @override
  State<SalesDetailScreen> createState() => _SalesDetailScreenState();
}

class _SalesDetailScreenState extends State<SalesDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color(0xff0b090a),
      
      appBar: AppBar(
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        
        title: Text("Sales Information", style: TextStyle(
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
            inputContainer(Text("Serial Number : ${SalesDetailScreen.serialNumber}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Stock Date : ${SalesDetailScreen.stockDate}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Import Method : ${SalesDetailScreen.import}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Chassis Number : ${SalesDetailScreen.chassis}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Model Name : ${SalesDetailScreen.modelName}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Variant Name : ${SalesDetailScreen.variantName}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Model Color : ${SalesDetailScreen.modelColor}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Ex-Showroom : ${SalesDetailScreen.exShowRoom}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Insurance : ${SalesDetailScreen.insurance}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("RTO : ${SalesDetailScreen.rto}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("HP : ${SalesDetailScreen.hp}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Pro Pack : ${SalesDetailScreen.proPack}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Total : ${SalesDetailScreen.total}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Stock Status : ${SalesDetailScreen.stockStatus}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Sales Date : ${SalesDetailScreen.salesDate}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Payment Type : ${SalesDetailScreen.paymentType}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Dis Amount : ${SalesDetailScreen.disAmount}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Customer Name : ${SalesDetailScreen.customerName}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Down Payment : ${SalesDetailScreen.downPayment}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Received Amount : ${SalesDetailScreen.receivedAmount}",style: textStyle())),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}