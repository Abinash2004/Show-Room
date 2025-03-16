import 'package:flutter/material.dart';
import 'package:show_room/elements/widgets.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({super.key});

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

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color(0xff0b090a),
      
      appBar: AppBar(
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        
        title: Text("Stock Information", style: TextStyle(
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
            inputContainer(Text("Serial Number : ${StockDetailScreen.serialNumber}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Stock Date : ${StockDetailScreen.stockDate}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Import Method : ${StockDetailScreen.import}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Chassis Number : ${StockDetailScreen.chassis}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Model Name : ${StockDetailScreen.modelName}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Variant Name : ${StockDetailScreen.variantName}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Model Color : ${StockDetailScreen.modelColor}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Ex-Showroom : ${StockDetailScreen.exShowRoom}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Insurance : ${StockDetailScreen.insurance}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("RTO : ${StockDetailScreen.rto}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("HP : ${StockDetailScreen.hp}",style: textStyle())),
            SizedBox(height: 10),
            inputContainer(Text("Pro Pack : ${StockDetailScreen.proPack}",style: textStyle())),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}