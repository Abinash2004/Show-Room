import 'package:flutter/material.dart';
import 'package:show_room/elements/functions.dart';
import 'package:show_room/elements/widgets.dart';

class DisburseScreen extends StatefulWidget {
  const DisburseScreen({super.key});

  static var serial = "";
  static var customerName = "";

  @override
  State<DisburseScreen> createState() => _DisburseScreenState();
}

class _DisburseScreenState extends State<DisburseScreen> {
  
  var disburse = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 10, 10),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        title: Text("Add Disburse Amount", style: TextStyle(
          color: Colors.white60,
          fontSize: 25,
          fontWeight: FontWeight.w600
        )),
        backgroundColor: Color(0xff0b090a),
        automaticallyImplyLeading: false,
        actions: [

          IconButton(
            onPressed: () async {

              if(disburse.text.isEmpty || DisburseScreen.customerName.isEmpty) {
                snackbar("Incomplete Data", context);
              }
              else {
                await saveDisburseAmount(DisburseScreen.serial, disburse, context);
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

                inputContainer(Text("Customer Name : ${DisburseScreen.customerName}",style: textStyle())),
                SizedBox(height: 20),

                textField("Disburse Amount", disburse, true),
                SizedBox(height: 20),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}