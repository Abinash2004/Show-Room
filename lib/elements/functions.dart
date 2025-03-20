import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:show_room/Screen/After%20Sales/disburse.dart';
import 'package:show_room/Screen/After%20Sales/invoice.dart';
import 'package:show_room/Screen/After%20Sales/vehicle_number.dart';
import 'package:show_room/Screen/Customer/add_customer.dart';
import 'package:show_room/Screen/Due/add_due.dart';
import 'package:show_room/Screen/Expense/add_expense.dart';
import 'package:show_room/Screen/Deposit/add_deposit.dart';
import 'package:show_room/Screen/Receive/add_receive.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:show_room/Screen/Stock/add_stock.dart';
import 'package:show_room/Screen/Stock/modify_stock.dart';
import 'package:show_room/Screen/home.dart';
import 'package:show_room/Screen/login.dart';
import 'package:show_room/elements/widgets.dart';
import 'package:show_room/main.dart';

Future<void> login(var code, var context) async {
  try {
    final databaseRef = FirebaseDatabase.instance.ref();
    var databaseSnapshot = await databaseRef.child('Login').get();

    if(databaseSnapshot.child(code.toString()).exists) {

      LoginScreen.error = "";
      if (databaseSnapshot.child(code.toString()).value.toString() == "Admin") {
        MyApp.user = "Admin";
      } else {
        MyApp.user = "Staff";
        MyApp.location = databaseSnapshot.child(code.toString()).value.toString();
      }
      
      Navigator.push(context,MaterialPageRoute(builder: (context) => const HomeScreen()));
      
      snackbar("Logged In Successfully", context);
    
    } else {
      LoginScreen.error = "Incorrect Code";
    }
  }  catch (error) {
    LoginScreen.error = error.toString();
  }
}

Future<void> getStockSerialNumber() async {
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Auto').get();
  if(databaseSnapshot.value != null) {
    AddStockScreen.serial = databaseSnapshot.child("Stock Serial Number").value.toString();
  }
}

Future<void> getCustomerSerialNumber() async {
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Auto').get();
  if(databaseSnapshot.value != null) {
    AddCustomerScreen.serial = databaseSnapshot.child("Customer Serial Number").value.toString();
  }
}

Future<void> getDueSerialNumber() async {
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Auto').get();
  if(databaseSnapshot.value != null) {
    AddDueScreen.serial = databaseSnapshot.child("Due Serial Number").value.toString();
  }
}

Future<void> getDepositSerialNumber() async {
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Auto').get();
  if(databaseSnapshot.value != null) {
    DepositScreen.serial = databaseSnapshot.child("Deposit Serial Number").value.toString();
  }
}

Future<void> getReceiveSerialNumber() async {
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Auto').get();
  if(databaseSnapshot.value != null) {
    ReceiveScreen.serial = databaseSnapshot.child("Receive Serial Number").value.toString();
  }
}

Future<void> getExpenseSerialNumber() async {
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Auto').get();
  if(databaseSnapshot.value != null) {
    AddExpenseScreen.serial = databaseSnapshot.child("Expense Serial Number").value.toString();
  }
}

Future<void> saveStock(var serial, var date, var import, var chassis, var model , var variant , var color, var exShowRoom, var insurance, var rto, var hp, var proPack,var stockStatus, var isUpdate, var context) async {
  
  int total = (int.tryParse(exShowRoom.text) ?? 0) + 
              (int.tryParse(insurance.text) ?? 0) + 
              (int.tryParse(rto.text) ?? 0) + 
              (int.tryParse(hp.text) ?? 0) + 
              (int.tryParse(proPack.text) ?? 0);
  
  final databaseRef = FirebaseDatabase.instance.ref();
  databaseRef.child("Database").child(MyApp.location).child('Stock').child((serial == "1") ? "01" : serial.toString()).set({
    'Serial Number': serial.toString(),
    'Stock Date': date,
    'Import Method': import,
    'Chassis Number': chassis.toString().toUpperCase(),
    'Model Name': model.text,
    'Variant Name': variant.text,
    'Model Color': color.text,
    'Ex-Showroom Amount': exShowRoom.text,
    'Insurance Amount': insurance.text,
    'RTO Amount': rto.text,
    'HP Amount': hp.text,
    'Pro Pack Amount': proPack.text,
    'Stock Status': stockStatus,
    'Total Amount': total.toString(),
  }).then((value) async {
    
    if (!isUpdate) {
      int tempStock = 0;
      int tempCustomer = 0;
      int tempDue = 0;
      int tempDeposit = 0;
      int tempReceive = 0;
      int tempExpense = 0;
      var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child("Auto").get();
      if(databaseSnapshot.value != null) {
        tempStock = int.parse(databaseSnapshot.child("Stock Serial Number").value.toString());
        tempCustomer = int.parse(databaseSnapshot.child("Customer Serial Number").value.toString());
        tempDue = int.parse(databaseSnapshot.child("Due Serial Number").value.toString());
        tempDeposit = int.parse(databaseSnapshot.child("Deposit Serial Number").value.toString());
        tempReceive = int.parse(databaseSnapshot.child("Receive Serial Number").value.toString());
        tempExpense = int.parse(databaseSnapshot.child("Expense Serial Number").value.toString());
      }
      databaseRef.child("Database").child(MyApp.location).child('Auto').set({
        'Stock Serial Number' :  (tempStock + 1).toString(),
        'Customer Serial Number' :  (tempCustomer).toString(),
        'Due Serial Number' :  (tempDue).toString(),
        'Deposit Serial Number' :  (tempDeposit).toString(),
        'Receive Serial Number' :  (tempReceive).toString(),
        'Expense Serial Number' :  (tempExpense).toString(),
      });
      
      Navigator.pop(context);
      snackbar("Stock Added Successfully", context);
    } else {
      Navigator.pop(context);
      snackbar("Stock Modiefied Successfully", context);
    }
  });
}

Future<void> saveSales(var serial, var stockDate, var import, var chassis, var model , var variant , var color, var exShowRoom, var insurance, var rto, var hp, var proPack,var stockStatus,var salesDate,  var paymentType, var customerName, var receivedAmount, var context ) async {

   int total = (int.tryParse(exShowRoom.text) ?? 0) + 
              (int.tryParse(insurance.text) ?? 0) + 
              (int.tryParse(rto.text) ?? 0) + 
              (int.tryParse(hp.text) ?? 0) + 
              (int.tryParse(proPack.text) ?? 0);
  
  final databaseRef = FirebaseDatabase.instance.ref();
  databaseRef.child("Database").child(MyApp.location).child('Stock').child((serial == "1") ? "01" : serial.toString()).set({
    'Serial Number': serial.toString(),
    'Stock Date': stockDate,
    'Import Method': import,
    'Chassis Number': chassis.toString().toUpperCase(),
    'Model Name': model.text,
    'Variant Name': variant.text,
    'Model Color': color.text,
    'Ex-Showroom Amount': exShowRoom.text,
    'Insurance Amount': insurance.text,
    'RTO Amount': rto.text,
    'HP Amount': hp.text,
    'Pro Pack Amount': proPack.text,
    'Stock Status': stockStatus,
    'Total Amount': total.toString(),
    'Sales Date': salesDate,
    'Payment Type' : paymentType,
    'Customer Name' : customerName.text,
    'Received Amount' : receivedAmount.text
  }).then((value) async {
    Navigator.pop(context);
    snackbar("Stock Modiefied Successfully", context);
  });
}

Future<void> getStockReport(var stockSerial, context) async {
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Stock').child((stockSerial.text.toString() == "1") ? "01" : stockSerial.text.toString()).get(); 
  if(databaseSnapshot.value != null) {
    ModifyStockScreen.serial = databaseSnapshot.child("Serial Number").value.toString();
    ModifyStockScreen.stockDate = databaseSnapshot.child("Stock Date").value.toString();
    ModifyStockScreen.import = databaseSnapshot.child("Import Method").value.toString();
    ModifyStockScreen.chassis = databaseSnapshot.child("Chassis Number").value.toString();
    ModifyStockScreen.model = databaseSnapshot.child("Model Name").value.toString();
    ModifyStockScreen.variant = databaseSnapshot.child("Variant Name").value.toString();
    ModifyStockScreen.color = databaseSnapshot.child("Model Color").value.toString();
    ModifyStockScreen.exShowRoom = databaseSnapshot.child("Ex-Showroom Amount").value.toString();
    ModifyStockScreen.insurance = databaseSnapshot.child("Insurance Amount").value.toString();
    ModifyStockScreen.rto = databaseSnapshot.child("RTO Amount").value.toString();
    ModifyStockScreen.hp = databaseSnapshot.child("HP Amount").value.toString();
    ModifyStockScreen.proPack = databaseSnapshot.child("Pro Pack Amount").value.toString();
    ModifyStockScreen.stockStatus = databaseSnapshot.child("Stock Status").value.toString();
    if(ModifyStockScreen.stockStatus == "Sold") {
      ModifyStockScreen.salesDate = databaseSnapshot.child("Sales Date").value.toString();
      ModifyStockScreen.paymentType = databaseSnapshot.child("Payment Type").value.toString();
      ModifyStockScreen.disAmount = databaseSnapshot.child("Dis Amount").value.toString();
      ModifyStockScreen.customerName = databaseSnapshot.child("Customer Name").value.toString();
      ModifyStockScreen.receviedAmount = databaseSnapshot.child("Received Amount").value.toString();
    } else if(ModifyStockScreen.stockStatus == "Returned") {
      ModifyStockScreen.salesDate = databaseSnapshot.child("Sales Date").value.toString();
      ModifyStockScreen.customerName = databaseSnapshot.child("Customer Name").value.toString();
    }
  }
  if(databaseSnapshot.child("Stock Date").value.toString() == "null") {
    clearStockData();
  }
}

void clearStockData() {
    ModifyStockScreen.stockDate = "";
    ModifyStockScreen.import = "By Load";
    ModifyStockScreen.chassis = "";
    ModifyStockScreen.model = "";
    ModifyStockScreen.variant = "";
    ModifyStockScreen.color = "";
    ModifyStockScreen.exShowRoom = "";
    ModifyStockScreen.insurance = "";
    ModifyStockScreen.rto = "";
    ModifyStockScreen.hp = "";
    ModifyStockScreen.proPack = "";
    ModifyStockScreen.stockStatus = "Stock";
    ModifyStockScreen.salesDate = "Select a Date";
    ModifyStockScreen.paymentType = "Cash";
    ModifyStockScreen.disAmount = "";
    ModifyStockScreen.customerName = "";
    ModifyStockScreen.receviedAmount = "";
    InvoiceScreen.customerName = "";
    VehicleNumberScreen.customerName = "";
}

Future<void> createStockExcel() async {

  String red = "#cf4747";
  String green = "#53a942";

  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName("A1").setText("SERIAL NO");
  sheet.getRangeByName("B1").setText("STOCK DATE");
  sheet.getRangeByName("C1").setText("IMPORT METHOD");
  sheet.getRangeByName("D1").setText("CHASSIS NUMBER");
  sheet.getRangeByName("E1").setText("MODEL NAME");
  sheet.getRangeByName("F1").setText("VARIANT NAME");
  sheet.getRangeByName("G1").setText("MODEL COLOR");
  sheet.getRangeByName("H1").setText("EX-SHOWROOM");
  sheet.getRangeByName("I1").setText("INSURANCE");
  sheet.getRangeByName("J1").setText("RTO");
  sheet.getRangeByName("K1").setText("HP");
  sheet.getRangeByName("L1").setText("PRO PACK");
  sheet.getRangeByName("M1").setText("TOTAL AMOUNT");
  sheet.getRangeByName("N1").setText("STOCK STATUS");
  sheet.getRangeByName("O1").setText("SALES DATE");
  sheet.getRangeByName("P1").setText("PAYMENT TYPE");
  sheet.getRangeByName("Q1").setText("CUSTOMER NAME");
  sheet.getRangeByName("R1").setText("RECEIVED AMOUNT");
  sheet.getRangeByName("S1").setText("DIS AMOUNT");
  sheet.getRangeByName("T1").setText("DOWN PAYMENT");
  sheet.getRangeByName("U1").setText("INVOICE NUMBER");
  sheet.getRangeByName("V1").setText("INVOICE DATE");
  sheet.getRangeByName("W1").setText("VEHICLE NUMBER");
  
  for (int i=0; i<HomeScreen.stockList.length; i++) {
    sheet.getRangeByName("A${i+3}").setText(HomeScreen.stockList[i]["Serial Number"].toString().toUpperCase());
    sheet.getRangeByName("B${i+3}").setText(HomeScreen.stockList[i]["Stock Date"].toString().toUpperCase());
    sheet.getRangeByName("C${i+3}").setText(HomeScreen.stockList[i]["Import Method"].toString().toUpperCase());
    sheet.getRangeByName("D${i+3}").setText(HomeScreen.stockList[i]["Chassis Number"].toString().toUpperCase());
    sheet.getRangeByName("E${i+3}").setText(HomeScreen.stockList[i]["Model Name"].toString().toUpperCase());
    sheet.getRangeByName("F${i+3}").setText(HomeScreen.stockList[i]["Variant Name"].toString().toUpperCase());
    sheet.getRangeByName("G${i+3}").setText(HomeScreen.stockList[i]["Model Color"].toString().toUpperCase());
    sheet.getRangeByName("H${i+3}").setText(HomeScreen.stockList[i]["Ex-Showroom Amount"].toString().toUpperCase());
    sheet.getRangeByName("I${i+3}").setText(HomeScreen.stockList[i]["Insurance Amount"].toString().toUpperCase());
    sheet.getRangeByName("J${i+3}").setText(HomeScreen.stockList[i]["RTO Amount"].toString().toUpperCase());
    sheet.getRangeByName("K${i+3}").setText(HomeScreen.stockList[i]["HP Amount"].toString().toUpperCase());
    sheet.getRangeByName("L${i+3}").setText(HomeScreen.stockList[i]["Pro Pack Amount"].toString().toUpperCase());
    sheet.getRangeByName("M${i+3}").setText(HomeScreen.stockList[i]["Total Amount"].toString().toUpperCase());
    sheet.getRangeByName("N${i+3}").setText(HomeScreen.stockList[i]["Stock Status"].toString().toUpperCase());
    
    if(HomeScreen.stockList[i]["Stock Status"].toString() != "Stock") {
      sheet.getRangeByName("O${i+3}").setText(HomeScreen.stockList[i]["Sales Date"].toString().toUpperCase());
      sheet.getRangeByName("P${i+3}").setText(HomeScreen.stockList[i]["Payment Type"].toString().toUpperCase());
      sheet.getRangeByName("Q${i+3}").setText(HomeScreen.stockList[i]["Customer Name"].toString().toUpperCase());
      sheet.getRangeByName("R${i+3}").setText(HomeScreen.stockList[i]["Received Amount"].toString().toUpperCase());
    }

    if(HomeScreen.stockList[i]["Disburse Amount"].toString() != "null") {
      sheet.getRangeByName("S${i+3}").setText(HomeScreen.stockList[i]["Disburse Amount"].toString().toUpperCase());
      sheet.getRangeByName("T${i+3}").setText(HomeScreen.stockList[i]["Down Payment"].toString().toUpperCase());
    }

    if(HomeScreen.stockList[i]["Stock Status"] == "Returned") {
      sheet.getRangeByName("N${i+3}").cellStyle.backColor = red;
    } else if(HomeScreen.stockList[i]["Stock Status"] == "Sold") {
      sheet.getRangeByName("N${i+3}").cellStyle.backColor = green;
    }

    if(HomeScreen.stockList[i]["Invoice Number"].toString() != "null") {
      sheet.getRangeByName("U${i+3}").setText(HomeScreen.stockList[i]["Invoice Number"].toString().toUpperCase());
      sheet.getRangeByName("V${i+3}").setText(HomeScreen.stockList[i]["Invoice Date"].toString().toUpperCase());
    }
    if(HomeScreen.stockList[i]["Vehicle Number"].toString() != "null") {
      sheet.getRangeByName("W${i+3}").setText(HomeScreen.stockList[i]["Vehicle Number"].toString().toUpperCase());
    }
  }
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path/all-data.xls';

  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open(fileName);
}

Future<void> createViewSalesExcel() async {
  
  String red = "#cf4747";
  String green = "#53a942";
  
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName("A1").setText("SERIAL NO");
  sheet.getRangeByName("B1").setText("STOCK DATE");
  sheet.getRangeByName("C1").setText("IMPORT METHOD");
  sheet.getRangeByName("D1").setText("CHASSIS NUMBER");
  sheet.getRangeByName("E1").setText("MODEL NAME");
  sheet.getRangeByName("F1").setText("VARIANT NAME");
  sheet.getRangeByName("G1").setText("MODEL COLOR");
  sheet.getRangeByName("H1").setText("EX-SHOWROOM");
  sheet.getRangeByName("I1").setText("INSURANCE");
  sheet.getRangeByName("J1").setText("RTO");
  sheet.getRangeByName("K1").setText("HP");
  sheet.getRangeByName("L1").setText("PRO PACK");
  sheet.getRangeByName("M1").setText("TOTAL AMOUNT");
  sheet.getRangeByName("N1").setText("STOCK STATUS");
  sheet.getRangeByName("O1").setText("SALES DATE");
  sheet.getRangeByName("P1").setText("PAYMENT TYPE");
  sheet.getRangeByName("Q1").setText("CUSTOMER NAME");
  sheet.getRangeByName("R1").setText("RECEIVED AMOUNT");
  int x = 0;
  for (int i=0; i<HomeScreen.stockList.length; i++) {
    if(HomeScreen.stockList[i]["Stock Status"].toString() != "Stock") {
      sheet.getRangeByName("A${x+3}").setText(HomeScreen.stockList[i]["Serial Number"].toString().toUpperCase());
      sheet.getRangeByName("B${x+3}").setText(HomeScreen.stockList[i]["Stock Date"].toString().toUpperCase());
      sheet.getRangeByName("C${x+3}").setText(HomeScreen.stockList[i]["Import Method"].toString().toUpperCase());
      sheet.getRangeByName("D${x+3}").setText(HomeScreen.stockList[i]["Chassis Number"].toString().toUpperCase());
      sheet.getRangeByName("E${x+3}").setText(HomeScreen.stockList[i]["Model Name"].toString().toUpperCase());
      sheet.getRangeByName("F${x+3}").setText(HomeScreen.stockList[i]["Variant Name"].toString().toUpperCase());
      sheet.getRangeByName("G${x+3}").setText(HomeScreen.stockList[i]["Model Color"].toString().toUpperCase());
      sheet.getRangeByName("H${x+3}").setText(HomeScreen.stockList[i]["Ex-Showroom Amount"].toString().toUpperCase());
      sheet.getRangeByName("I${x+3}").setText(HomeScreen.stockList[i]["Insurance Amount"].toString().toUpperCase());
      sheet.getRangeByName("J${x+3}").setText(HomeScreen.stockList[i]["RTO Amount"].toString().toUpperCase());
      sheet.getRangeByName("K${x+3}").setText(HomeScreen.stockList[i]["HP Amount"].toString().toUpperCase());
      sheet.getRangeByName("L${x+3}").setText(HomeScreen.stockList[i]["Pro Pack Amount"].toString().toUpperCase());
      sheet.getRangeByName("M${x+3}").setText(HomeScreen.stockList[i]["Total Amount"].toString().toUpperCase());
      sheet.getRangeByName("N${x+3}").setText(HomeScreen.stockList[i]["Stock Status"].toString().toUpperCase());
      sheet.getRangeByName("O${x+3}").setText(HomeScreen.stockList[i]["Sales Date"].toString().toUpperCase());
      sheet.getRangeByName("P${x+3}").setText(HomeScreen.stockList[i]["Payment Type"].toString().toUpperCase());
      sheet.getRangeByName("Q${x+3}").setText(HomeScreen.stockList[i]["Customer Name"].toString().toUpperCase());
      sheet.getRangeByName("R${x+3}").setText(HomeScreen.stockList[i]["Received Amount"].toString().toUpperCase());
      
      if(HomeScreen.stockList[i]["Stock Status"] == "Returned") {
        sheet.getRangeByName("N${x+3}").cellStyle.backColor = red;
      } else if(HomeScreen.stockList[i]["Stock Status"] == "Sold") {
        sheet.getRangeByName("N${x+3}").cellStyle.backColor = green;
      } 
      x++;
    }
  }
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path/sales.xls';

  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open(fileName);
}

Future<void> createViewStockExcel() async {

  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName("A1").setText("SERIAL NO");
  sheet.getRangeByName("B1").setText("STOCK DATE");
  sheet.getRangeByName("C1").setText("IMPORT METHOD");
  sheet.getRangeByName("D1").setText("CHASSIS NUMBER");
  sheet.getRangeByName("E1").setText("MODEL NAME");
  sheet.getRangeByName("F1").setText("VARIANT NAME");
  sheet.getRangeByName("G1").setText("MODEL COLOR");
  sheet.getRangeByName("H1").setText("EX-SHOWROOM");
  sheet.getRangeByName("I1").setText("INSURANCE");
  sheet.getRangeByName("J1").setText("RTO");
  sheet.getRangeByName("K1").setText("HP");
  sheet.getRangeByName("L1").setText("PRO PACK");
  sheet.getRangeByName("M1").setText("TOTAL AMOUNT");
  
  int x = 0;
  for (int i=0; i<HomeScreen.stockList.length; i++) {
    if(HomeScreen.stockList[i]["Stock Status"] == "Stock") {

      sheet.getRangeByName("A${x+3}").setText(HomeScreen.stockList[i]["Serial Number"].toString().toUpperCase());
      sheet.getRangeByName("B${x+3}").setText(HomeScreen.stockList[i]["Stock Date"].toString().toUpperCase());
      sheet.getRangeByName("C${x+3}").setText(HomeScreen.stockList[i]["Import Method"].toString().toUpperCase());
      sheet.getRangeByName("D${x+3}").setText(HomeScreen.stockList[i]["Chassis Number"].toString().toUpperCase());
      sheet.getRangeByName("E${x+3}").setText(HomeScreen.stockList[i]["Model Name"].toString().toUpperCase());
      sheet.getRangeByName("F${x+3}").setText(HomeScreen.stockList[i]["Variant Name"].toString().toUpperCase());
      sheet.getRangeByName("G${x+3}").setText(HomeScreen.stockList[i]["Model Color"].toString().toUpperCase());
      sheet.getRangeByName("H${x+3}").setText(HomeScreen.stockList[i]["Ex-Showroom Amount"].toString().toUpperCase());
      sheet.getRangeByName("I${x+3}").setText(HomeScreen.stockList[i]["Insurance Amount"].toString().toUpperCase());
      sheet.getRangeByName("J${x+3}").setText(HomeScreen.stockList[i]["RTO Amount"].toString().toUpperCase());
      sheet.getRangeByName("K${x+3}").setText(HomeScreen.stockList[i]["HP Amount"].toString().toUpperCase());
      sheet.getRangeByName("L${x+3}").setText(HomeScreen.stockList[i]["Pro Pack Amount"].toString().toUpperCase());
      sheet.getRangeByName("M${x+3}").setText(HomeScreen.stockList[i]["Total Amount"].toString().toUpperCase());
      x++;
    }
  }
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path/stock.xls';

  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open(fileName);
}

Future<void> saveInvoice(var serial, var invoiceNumber, var invoiceDate, var context ) async {
  
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Stock').child((serial == "1") ? "01" : serial.toString()).get(); 
  
  if(databaseSnapshot.value != null) {
  
    if(databaseSnapshot.child("Stock Status").value.toString() == "Sold") {

      var serialNumber = databaseSnapshot.child("Serial Number").value.toString();
      var stockDate = databaseSnapshot.child("Stock Date").value.toString();
      var import = databaseSnapshot.child("Import Method").value.toString();
      var chassis = databaseSnapshot.child("Chassis Number").value.toString();
      var model = databaseSnapshot.child("Model Name").value.toString();
      var variant = databaseSnapshot.child("Variant Name").value.toString();
      var color = databaseSnapshot.child("Model Color").value.toString();
      var exShowRoom = databaseSnapshot.child("Ex-Showroom Amount").value.toString();
      var insurance = databaseSnapshot.child("Insurance Amount").value.toString();
      var rto = databaseSnapshot.child("RTO Amount").value.toString();
      var hp = databaseSnapshot.child("HP Amount").value.toString();
      var proPack = databaseSnapshot.child("Pro Pack Amount").value.toString();
      var total = databaseSnapshot.child("Total Amount").value.toString();
      var stockStatus = databaseSnapshot.child("Stock Status").value.toString();
      var salesDate = databaseSnapshot.child("Sales Date").value.toString();
      var paymentType = databaseSnapshot.child("Payment Type").value.toString();
      var disAmount = databaseSnapshot.child("Dis Amount").value.toString();
      var customerName = databaseSnapshot.child("Customer Name").value.toString();
      var downPayment = databaseSnapshot.child("Down Payment").value.toString();
      var receivedAmount = databaseSnapshot.child("Received Amount").value.toString();

      databaseRef.child("Database").child(MyApp.location).child('Stock').child((serial == "1") ? "01" : serial.toString()).set({
        'Serial Number': serialNumber,
        'Stock Date': stockDate,
        'Import Method': import,
        'Chassis Number': chassis.toString().toUpperCase(),
        'Model Name': model,
        'Variant Name': variant,
        'Model Color': color,
        'Ex-Showroom Amount': exShowRoom,
        'Insurance Amount': insurance,
        'RTO Amount': rto,
        'HP Amount': hp,
        'Pro Pack Amount': proPack,
        'Stock Status': stockStatus,
        'Total Amount': total,
        'Sales Date': salesDate,
        'Payment Type' : paymentType,
        'Dis Amount' : disAmount,
        'Customer Name' : customerName,
        'Down Payment' : downPayment,
        'Received Amount' : receivedAmount,
        'Invoice Number' : invoiceNumber.text,
        "Invoice Date" : invoiceDate
      }).then((value) async {
        Navigator.pop(context);
        snackbar("Invoice Added Successfully", context);
      });

    }
   }
}

Future<void> saveVehicleNumber(var serial,var vehicleNumber, var context ) async {
  
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Stock').child((serial == "1") ? "01" : serial.toString()).get(); 
  
  if(databaseSnapshot.value != null) {
    if(databaseSnapshot.child("Stock Status").value.toString() == "Sold") {

      var serialNumber = databaseSnapshot.child("Serial Number").value.toString();
      var stockDate = databaseSnapshot.child("Stock Date").value.toString();
      var import = databaseSnapshot.child("Import Method").value.toString();
      var chassis = databaseSnapshot.child("Chassis Number").value.toString();
      var model = databaseSnapshot.child("Model Name").value.toString();
      var variant = databaseSnapshot.child("Variant Name").value.toString();
      var color = databaseSnapshot.child("Model Color").value.toString();
      var exShowRoom = databaseSnapshot.child("Ex-Showroom Amount").value.toString();
      var insurance = databaseSnapshot.child("Insurance Amount").value.toString();
      var rto = databaseSnapshot.child("RTO Amount").value.toString();
      var hp = databaseSnapshot.child("HP Amount").value.toString();
      var proPack = databaseSnapshot.child("Pro Pack Amount").value.toString();
      var total = databaseSnapshot.child("Total Amount").value.toString();
      var stockStatus = databaseSnapshot.child("Stock Status").value.toString();
      var salesDate = databaseSnapshot.child("Sales Date").value.toString();
      var paymentType = databaseSnapshot.child("Payment Type").value.toString();
      var disAmount = databaseSnapshot.child("Dis Amount").value.toString();
      var customerName = databaseSnapshot.child("Customer Name").value.toString();
      var downPayment = databaseSnapshot.child("Down Payment").value.toString();
      var receivedAmount = databaseSnapshot.child("Received Amount").value.toString();
      var invoiceNumber = databaseSnapshot.child("Invoice Number").value.toString();
      var invoiceDate = databaseSnapshot.child("Invoice Date").value.toString();

      databaseRef.child("Database").child(MyApp.location).child('Stock').child((serial == "1") ? "01" : serial.toString()).set({
        'Serial Number': serialNumber,
        'Stock Date': stockDate,
        'Import Method': import,
        'Chassis Number': chassis.toString().toUpperCase(),
        'Model Name': model,
        'Variant Name': variant,
        'Model Color': color,
        'Ex-Showroom Amount': exShowRoom,
        'Insurance Amount': insurance,
        'RTO Amount': rto,
        'HP Amount': hp,
        'Pro Pack Amount': proPack,
        'Stock Status': stockStatus,
        'Total Amount': total,
        'Sales Date': salesDate,
        'Payment Type' : paymentType,
        'Dis Amount' : disAmount,
        'Customer Name' : customerName,
        'Down Payment' : downPayment,
        'Received Amount' : receivedAmount,
        'Invoice Number' : invoiceNumber,
        "Invoice Date" : invoiceDate,
        "Vehicle Number" : vehicleNumber.text
      }).then((value) async {
        Navigator.pop(context);
        snackbar("Vehicle Number Added", context);
      });
    }
   }
}

Future<void> saveDisburseAmount(var serial,var disburse, var context ) async {
  
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Stock').child((serial == "1") ? "01" : serial.toString()).get(); 
  
  if(databaseSnapshot.value != null) {
    if(databaseSnapshot.child("Stock Status").value.toString() == "Sold") {

      var serialNumber = databaseSnapshot.child("Serial Number").value.toString();
      var stockDate = databaseSnapshot.child("Stock Date").value.toString();
      var import = databaseSnapshot.child("Import Method").value.toString();
      var chassis = databaseSnapshot.child("Chassis Number").value.toString();
      var model = databaseSnapshot.child("Model Name").value.toString();
      var variant = databaseSnapshot.child("Variant Name").value.toString();
      var color = databaseSnapshot.child("Model Color").value.toString();
      var exShowRoom = databaseSnapshot.child("Ex-Showroom Amount").value.toString();
      var insurance = databaseSnapshot.child("Insurance Amount").value.toString();
      var rto = databaseSnapshot.child("RTO Amount").value.toString();
      var hp = databaseSnapshot.child("HP Amount").value.toString();
      var proPack = databaseSnapshot.child("Pro Pack Amount").value.toString();
      var total = databaseSnapshot.child("Total Amount").value.toString();
      var stockStatus = databaseSnapshot.child("Stock Status").value.toString();
      var salesDate = databaseSnapshot.child("Sales Date").value.toString();
      var paymentType = databaseSnapshot.child("Payment Type").value.toString();
      var customerName = databaseSnapshot.child("Customer Name").value.toString();
      var receivedAmount = databaseSnapshot.child("Received Amount").value.toString();
    
      String downPayment = (int.parse(total) - int.parse(disburse.text)).toString();

      databaseRef.child("Database").child(MyApp.location).child('Stock').child((serial == "1") ? "01" : serial.toString()).set({
        'Serial Number': serialNumber,
        'Stock Date': stockDate,
        'Import Method': import,
        'Chassis Number': chassis.toString().toUpperCase(),
        'Model Name': model,
        'Variant Name': variant,
        'Model Color': color,
        'Ex-Showroom Amount': exShowRoom,
        'Insurance Amount': insurance,
        'RTO Amount': rto,
        'HP Amount': hp,
        'Pro Pack Amount': proPack,
        'Stock Status': stockStatus,
        'Total Amount': total,
        'Sales Date': salesDate,
        'Payment Type' : paymentType,
        'Disburse Amount' : disburse.text.toString(),
        'Customer Name' : customerName,
        'Down Payment' : downPayment,
        'Received Amount' : receivedAmount,
      }).then((value) async {
        Navigator.pop(context);
        snackbar("Disburse Amount Added", context);
      });
    }
   }
}

Future<void> saveDeposit(var serial, var date, var amount, var bank, var accountNumber, var depositor, var customerName, var context) async {
  
  final databaseRef = FirebaseDatabase.instance.ref();
  databaseRef.child("Database").child(MyApp.location).child('Deposit').child((serial == "1") ? "01" : serial.toString()).set({
    'Serial Number': serial.toString(),
    'Date': date,
    'Amount': amount.text,
    'Bank': bank.text,
    'Account Number': accountNumber.text,
    'Depositor': depositor.text,
    'Customer Name': customerName.text,
    'Status' : "Not Verified"
  }).then((value) async {
    
    int tempStock = 0;
      int tempCustomer = 0;
      int tempDue = 0;
      int tempDeposit = 0;
      int tempReceive = 0;
      int tempExpense = 0;
      var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child("Auto").get();
      if(databaseSnapshot.value != null) {
        tempStock = int.parse(databaseSnapshot.child("Stock Serial Number").value.toString());
        tempCustomer = int.parse(databaseSnapshot.child("Customer Serial Number").value.toString());
        tempDue = int.parse(databaseSnapshot.child("Due Serial Number").value.toString());
        tempDeposit = int.parse(databaseSnapshot.child("Deposit Serial Number").value.toString());
        tempReceive = int.parse(databaseSnapshot.child("Receive Serial Number").value.toString());
        tempExpense = int.parse(databaseSnapshot.child("Expense Serial Number").value.toString());
      }
      databaseRef.child("Database").child(MyApp.location).child('Auto').set({
        'Stock Serial Number' :  (tempStock).toString(),
        'Customer Serial Number' :  (tempCustomer).toString(),
        'Due Serial Number' :  (tempDue).toString(),
        'Deposit Serial Number' :  (tempDeposit + 1).toString(),
        'Receive Serial Number' :  (tempReceive).toString(),
        'Expense Serial Number' :  (tempExpense).toString(),
      });
      
    Navigator.pop(context);
    snackbar("Payment Added Successfully", context);
  });
}

Future<void> saveReceive(var serial, var date, var amount, var receiveDetails, var customerName, var receiverName, var context) async {
  
  final databaseRef = FirebaseDatabase.instance.ref();
  databaseRef.child("Database").child(MyApp.location).child('Receive').child((serial == "1") ? "01" : serial.toString()).set({
    'Serial Number': serial.toString(),
    'Date': date,
    'Amount': amount.text,
    'Receive Details': receiveDetails.text,
    'Customer Name': customerName.text,
    'Receiver Name': receiverName.text
  }).then((value) async {
    
    int tempStock = 0;
      int tempCustomer = 0;
      int tempDue = 0;
      int tempDeposit = 0;
      int tempReceive = 0;
      int tempExpense = 0;
      var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child("Auto").get();
      if(databaseSnapshot.value != null) {
        tempStock = int.parse(databaseSnapshot.child("Stock Serial Number").value.toString());
        tempCustomer = int.parse(databaseSnapshot.child("Customer Serial Number").value.toString());
        tempDue = int.parse(databaseSnapshot.child("Due Serial Number").value.toString());
        tempDeposit = int.parse(databaseSnapshot.child("Deposit Serial Number").value.toString());
        tempReceive = int.parse(databaseSnapshot.child("Receive Serial Number").value.toString());
        tempExpense = int.parse(databaseSnapshot.child("Expense Serial Number").value.toString());
      }
      databaseRef.child("Database").child(MyApp.location).child('Auto').set({
        'Stock Serial Number' :  (tempStock).toString(),
        'Customer Serial Number' :  (tempCustomer).toString(),
        'Due Serial Number' :  (tempDue).toString(),
        'Deposit Serial Number' :  (tempDeposit).toString(),
        'Receive Serial Number' :  (tempReceive + 1).toString(),
        'Expense Serial Number' :  (tempExpense).toString(),
      });
      
    Navigator.pop(context);
    snackbar("Payment Added Successfully", context);
  });
}

Future<void> saveExpense(var serial, var date, var amount, var purchase, var status, var context) async {
  
  final databaseRef = FirebaseDatabase.instance.ref();
  databaseRef.child("Database").child(MyApp.location).child('Expense').child((serial == "1") ? "01" : serial.toString()).set({
    'Serial Number': serial.toString(),
    'Date': date,
    'Amount': amount.text,
    'Expense Details': purchase.text,
    'Status': status
  }).then((value) async {
    
    int tempStock = 0;
      int tempCustomer = 0;
      int tempDue = 0;
      int tempDeposit = 0;
      int tempReceive = 0;
      int tempExpense = 0;
      var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child("Auto").get();
      if(databaseSnapshot.value != null) {
        tempStock = int.parse(databaseSnapshot.child("Stock Serial Number").value.toString());
        tempCustomer = int.parse(databaseSnapshot.child("Customer Serial Number").value.toString());
        tempDue = int.parse(databaseSnapshot.child("Due Serial Number").value.toString());
        tempDeposit = int.parse(databaseSnapshot.child("Deposit Serial Number").value.toString());
        tempReceive = int.parse(databaseSnapshot.child("Receive Serial Number").value.toString());
        tempExpense = int.parse(databaseSnapshot.child("Expense Serial Number").value.toString());
      }
      databaseRef.child("Database").child(MyApp.location).child('Auto').set({
        'Stock Serial Number' :  (tempStock).toString(),
        'Customer Serial Number' :  (tempCustomer).toString(),
        'Due Serial Number' :  (tempDue).toString(),
        'Deposit Serial Number' :  (tempDeposit).toString(),
        'Receive Serial Number' :  (tempReceive).toString(),
        'Expense Serial Number' :  (tempExpense + 1).toString(),
      });
      
    Navigator.pop(context);
    snackbar("Expense Added Successfully", context);
  });
}

Future<void> createDepositExcel() async {
  
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName("A1").setText("SERIAL NO");
  sheet.getRangeByName("B1").setText("DATE");
  sheet.getRangeByName("C1").setText("AMOUNT");
  sheet.getRangeByName("D1").setText("BANK");
  sheet.getRangeByName("E1").setText("ACCOUNT NUMBER");
  sheet.getRangeByName("F1").setText("DEPOSITOR");
  sheet.getRangeByName("G1").setText("CUSTOMER NAME");
  sheet.getRangeByName("H1").setText("STATUS");
  
  for (int i=0; i<HomeScreen.depositList.length; i++) {
    sheet.getRangeByName("A${i+3}").setText(HomeScreen.depositList[i]["Serial Number"].toString().toUpperCase());
    sheet.getRangeByName("B${i+3}").setText(HomeScreen.depositList[i]["Date"].toString().toUpperCase());
    sheet.getRangeByName("C${i+3}").setText(HomeScreen.depositList[i]["Amount"].toString().toUpperCase());
    sheet.getRangeByName("D${i+3}").setText(HomeScreen.depositList[i]["Bank"].toString().toUpperCase());
    sheet.getRangeByName("E${i+3}").setText(HomeScreen.depositList[i]["Account Number"].toString().toUpperCase());
    sheet.getRangeByName("F${i+3}").setText(HomeScreen.depositList[i]["Depositor"].toString().toUpperCase());
    sheet.getRangeByName("G${i+3}").setText(HomeScreen.depositList[i]["Customer Name"].toString().toUpperCase());
    sheet.getRangeByName("H${i+3}").setText(HomeScreen.depositList[i]["Status"].toString().toUpperCase());
  }
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path/Deposite.xls';

  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open(fileName);
}

Future<void> createReceiveExcel() async {
  
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName("A1").setText("SERIAL NO");
  sheet.getRangeByName("B1").setText("DATE");
  sheet.getRangeByName("C1").setText("AMOUNT");
  sheet.getRangeByName("D1").setText("RECEIVE DETAILS");
  sheet.getRangeByName("E1").setText("CUSTOMER NAME");
  sheet.getRangeByName("F1").setText("RECEIVER NAME");
  
  for (int i=0; i<HomeScreen.receiveList.length; i++) {
    sheet.getRangeByName("A${i+3}").setText(HomeScreen.receiveList[i]["Serial Number"].toString().toUpperCase());
    sheet.getRangeByName("B${i+3}").setText(HomeScreen.receiveList[i]["Date"].toString().toUpperCase());
    sheet.getRangeByName("C${i+3}").setText(HomeScreen.receiveList[i]["Amount"].toString().toUpperCase());
    sheet.getRangeByName("D${i+3}").setText(HomeScreen.receiveList[i]["Receive Details"].toString().toUpperCase());
    sheet.getRangeByName("E${i+3}").setText(HomeScreen.receiveList[i]["Customer Name"].toString().toUpperCase());
    sheet.getRangeByName("F${i+3}").setText(HomeScreen.receiveList[i]["Receiver Name"].toString().toUpperCase());
  }
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path/Receive.xls';

  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open(fileName);
}

Future<void> createExpenseExcel() async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName("A1").setText("SERIAL NO");
  sheet.getRangeByName("B1").setText("DATE");
  sheet.getRangeByName("C1").setText("AMOUNT");
  sheet.getRangeByName("D1").setText("PURCHASE");
  sheet.getRangeByName("E1").setText("STATUS");
  
  for (int i=0; i<HomeScreen.expenseList.length; i++) {
    sheet.getRangeByName("A${i+3}").setText(HomeScreen.expenseList[i]["Serial Number"].toString().toUpperCase());
    sheet.getRangeByName("B${i+3}").setText(HomeScreen.expenseList[i]["Date"].toString().toUpperCase());
    sheet.getRangeByName("C${i+3}").setText(HomeScreen.expenseList[i]["Amount"].toString().toUpperCase());
    sheet.getRangeByName("D${i+3}").setText(HomeScreen.expenseList[i]["Expense Details"].toString().toUpperCase());
    sheet.getRangeByName("E${i+3}").setText(HomeScreen.expenseList[i]["Status"].toString().toUpperCase());
  }
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path/Expense.xls';

  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open(fileName);
}

Future<void> saveCustomer(var serial, var visitDate, var customerName, var contactNumber, var address, var model , var variant , var color, var customerStatus, var paymentType, var followUpDate, var remark1, var remark2, var isUpdate, var context) async {
  
  final databaseRef = FirebaseDatabase.instance.ref();
  databaseRef.child("Database").child(MyApp.location).child('Customer').child((serial == "1") ? "01" : serial.toString()).set({
    'Serial Number': serial.toString(),
    'Visit Date': visitDate,
    'Customer Name': customerName.text,
    'Contact Number': contactNumber.text,
    'Address': address.text,
    'Model Name': model.text.toString().toUpperCase(),
    'Variant Name': variant.text,
    'Model Color': color.text,
    'Customer Status': customerStatus,
    'Payment Type': paymentType,
    'Follow Up Date': (followUpDate == "Select a Date") ? "" : followUpDate,
    'Remark 1': remark1.text,
    'Remark 2': remark2.text,
  }).then((value) async {
    
    if (!isUpdate) {
      int tempStock = 0;
      int tempCustomer = 0;
      int tempDue = 0;
      int tempDeposit = 0;
      int tempReceive = 0;
      int tempExpense = 0;
      var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child("Auto").get();
      if(databaseSnapshot.value != null) {
        tempStock = int.parse(databaseSnapshot.child("Stock Serial Number").value.toString());
        tempCustomer = int.parse(databaseSnapshot.child("Customer Serial Number").value.toString());
        tempDue = int.parse(databaseSnapshot.child("Due Serial Number").value.toString());
        tempDeposit = int.parse(databaseSnapshot.child("Deposit Serial Number").value.toString());
        tempReceive = int.parse(databaseSnapshot.child("Receive Serial Number").value.toString());
        tempExpense = int.parse(databaseSnapshot.child("Expense Serial Number").value.toString());
      }
      databaseRef.child("Database").child(MyApp.location).child('Auto').set({
        'Stock Serial Number' :  (tempStock).toString(),
        'Customer Serial Number' :  (tempCustomer + 1).toString(),
        'Due Serial Number' :  (tempDue).toString(),
        'Deposit Serial Number' :  (tempDeposit).toString(),
        'Receive Serial Number' :  (tempReceive).toString(),
        'Expense Serial Number' :  (tempExpense).toString(),
      });
      
      Navigator.pop(context);
      snackbar("Customer Added Successfully", context);
    } else {
      Navigator.pop(context);
      snackbar("Modiefied Successfully", context);
    }
  });
}

Future<void> createCustomerExcel() async {

  String red = "#cf4747";
  String green = "#53a942";
  String orange = "#FFA500";
  String cyan = "#008dd8";


  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName("A1").setText("SERIAL NUMBER");
  sheet.getRangeByName("B1").setText("VISIT DATE");
  sheet.getRangeByName("C1").setText("CUSTOMER NAME");
  sheet.getRangeByName("D1").setText("CONTACT NUMBER");
  sheet.getRangeByName("E1").setText("ADDRESS");
  sheet.getRangeByName("F1").setText("MODEL NAME");
  sheet.getRangeByName("G1").setText("VARIANT NAME");
  sheet.getRangeByName("H1").setText("MODEL COLOR");
  sheet.getRangeByName("I1").setText("CUSTOMER STATUS");
  sheet.getRangeByName("J1").setText("PAYMENT TYPE");
  sheet.getRangeByName("K1").setText("FOLLOW UP STATUS");
  sheet.getRangeByName("L1").setText("REMARK 1");
  sheet.getRangeByName("M1").setText("REMARK 2");
  
  for (int i=0; i<HomeScreen.customerList.length; i++) {
    sheet.getRangeByName("A${i+3}").setText(HomeScreen.customerList[i]["Serial Number"].toString().toUpperCase());
    sheet.getRangeByName("B${i+3}").setText(HomeScreen.customerList[i]["Visit Date"].toString().toUpperCase());
    sheet.getRangeByName("C${i+3}").setText(HomeScreen.customerList[i]["Customer Name"].toString().toUpperCase());
    sheet.getRangeByName("D${i+3}").setText(HomeScreen.customerList[i]["Contact Number"].toString().toUpperCase());
    sheet.getRangeByName("E${i+3}").setText(HomeScreen.customerList[i]["Address"].toString().toUpperCase());
    sheet.getRangeByName("F${i+3}").setText(HomeScreen.customerList[i]["Model Name"].toString().toUpperCase());
    sheet.getRangeByName("G${i+3}").setText(HomeScreen.customerList[i]["Variant Name"].toString().toUpperCase());
    sheet.getRangeByName("H${i+3}").setText(HomeScreen.customerList[i]["Model Color"].toString().toUpperCase());
    sheet.getRangeByName("I${i+3}").setText(HomeScreen.customerList[i]["Customer Status"].toString().toUpperCase());
    sheet.getRangeByName("J${i+3}").setText(HomeScreen.customerList[i]["Payment Type"].toString().toUpperCase());
    sheet.getRangeByName("K${i+3}").setText(HomeScreen.customerList[i]["Follow Up Date"].toString().toUpperCase());
    sheet.getRangeByName("L${i+3}").setText(HomeScreen.customerList[i]["Remark 1"].toString().toUpperCase());
    sheet.getRangeByName("M${i+3}").setText(HomeScreen.customerList[i]["Remark 2"].toString().toUpperCase());
    
    if(HomeScreen.customerList[i]["Customer Status"] == "Hot") {
      sheet.getRangeByName("I${i+3}").cellStyle.backColor = red;
      sheet.getRangeByName("I${i+3}").cellStyle.fontColor = '#000000';
    } else if(HomeScreen.customerList[i]["Customer Status"] == "Warm") {
      sheet.getRangeByName("I${i+3}").cellStyle.backColor = orange;
      sheet.getRangeByName("I${i+3}").cellStyle.fontColor = '#000000';
    } else if(HomeScreen.customerList[i]["Customer Status"] == "Cold") {
      sheet.getRangeByName("I${i+3}").cellStyle.backColor = cyan;
    } else if(HomeScreen.customerList[i]["Customer Status"] == "Purchased") {
      sheet.getRangeByName("I${i+3}").cellStyle.backColor = green;
    }

  }
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path/Customer.xls';

  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open(fileName);
}

Future<void> saveDue(var serial, var name, var date, var phone, var totalDue, var dueStatus, var paidAmount1, var paidDate1, var paidAmount2, var paidDate2, var paidAmount3, var paidDate3, var paidAmount4, var paidDate4, var paidAmount5, var paidDate5, var isUpdate, var context) async {
  
  int remaining = (int.tryParse(totalDue.text) ?? 0) - ( 
              (int.tryParse(paidAmount1.text) ?? 0) + 
              (int.tryParse(paidAmount2.text) ?? 0) + 
              (int.tryParse(paidAmount3.text) ?? 0) + 
              (int.tryParse(paidAmount4.text) ?? 0) + 
              (int.tryParse(paidAmount5.text) ?? 0));
  
  final databaseRef = FirebaseDatabase.instance.ref();
  databaseRef.child("Database").child(MyApp.location).child('Due').child((serial == "1") ? "01" : serial.toString()).set({
    'Serial Number': serial.toString(),
    'Customer Name': name.text,
    'Date': date,
    'Phone Number': phone.text,
    'Total Due': totalDue.text,
    'Remaining Due': remaining.toString(),
    'Due Status': dueStatus,
    'Paid Amount 1': paidAmount1.text,
    'Paid Date 1': paidDate1,
    'Paid Amount 2': paidAmount2.text,
    'Paid Date 2': paidDate2,
    'Paid Amount 3': paidAmount3.text,
    'Paid Date 3': paidDate3,
    'Paid Amount 4': paidAmount4.text,
    'Paid Date 4': paidDate4,
    'Paid Amount 5': paidAmount5.text,
    'Paid Date 5': paidDate5,
  }).then((value) async {
    
    if (!isUpdate) {
      int tempStock = 0;
      int tempCustomer = 0;
      int tempDue = 0;
      int tempDeposit = 0;
      int tempReceive = 0;
      int tempExpense = 0;
      var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child("Auto").get();
      if(databaseSnapshot.value != null) {
        tempStock = int.parse(databaseSnapshot.child("Stock Serial Number").value.toString());
        tempCustomer = int.parse(databaseSnapshot.child("Customer Serial Number").value.toString());
        tempDue = int.parse(databaseSnapshot.child("Due Serial Number").value.toString());
        tempDeposit = int.parse(databaseSnapshot.child("Deposit Serial Number").value.toString());
        tempReceive = int.parse(databaseSnapshot.child("Receive Serial Number").value.toString());
        tempExpense = int.parse(databaseSnapshot.child("Expense Serial Number").value.toString());
      }
      databaseRef.child("Database").child(MyApp.location).child('Auto').set({
        'Stock Serial Number' :  (tempStock).toString(),
        'Customer Serial Number' :  (tempCustomer).toString(),
        'Due Serial Number' :  (tempDue + 1).toString(),
        'Deposit Serial Number' :  (tempDeposit).toString(),
        'Receive Serial Number' :  (tempReceive).toString(),
        'Expense Serial Number' :  (tempExpense).toString(),
      });
      
      Navigator.pop(context);
      snackbar("Due Added Successfully", context);
    } else {
      Navigator.pop(context);
      snackbar("Due Modiefied Successfully", context);
    }
  });
}

Future<void> createDueExcel() async {
  
  String red = "#cf4747";
  String green = "#53a942";

  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName("A1").setText("SERIAL NO");
  sheet.getRangeByName("B1").setText("CUSTOMER NAME");
  sheet.getRangeByName("C1").setText("DUE DATE");
  sheet.getRangeByName("D1").setText("PHONE NUMBER");
  sheet.getRangeByName("E1").setText("TOTAL DUE");
  sheet.getRangeByName("F1").setText("REMAINING DUE");
  sheet.getRangeByName("G1").setText("DUE STATUS");
  sheet.getRangeByName("H1").setText("PAID AMOUNT 1");
  sheet.getRangeByName("I1").setText("PAID DATE 1");
  sheet.getRangeByName("J1").setText("PAID AMOUNT 2");
  sheet.getRangeByName("K1").setText("PAID DATE 2");
  sheet.getRangeByName("L1").setText("PAID AMOUNT 3");
  sheet.getRangeByName("M1").setText("PAID DATE 3");
  sheet.getRangeByName("N1").setText("PAID AMOUNT 4");
  sheet.getRangeByName("O1").setText("PAID DATE 4");
  sheet.getRangeByName("P1").setText("PAID AMOUNT 5");
  sheet.getRangeByName("Q1").setText("PAID DATE 5");
  
  for (int i=0; i<HomeScreen.dueList.length; i++) {
    sheet.getRangeByName("A${i+3}").setText(HomeScreen.dueList[i]["Serial Number"].toString().toUpperCase());
    sheet.getRangeByName("B${i+3}").setText(HomeScreen.dueList[i]["Customer Name"].toString().toUpperCase());
    sheet.getRangeByName("C${i+3}").setText(HomeScreen.dueList[i]["Date"].toString().toUpperCase());
    sheet.getRangeByName("D${i+3}").setText(HomeScreen.dueList[i]["Phone Number"].toString().toUpperCase());
    sheet.getRangeByName("E${i+3}").setText(HomeScreen.dueList[i]["Total Due"].toString().toUpperCase());
    sheet.getRangeByName("F${i+3}").setText(HomeScreen.dueList[i]["Remaining Due"].toString().toUpperCase());
    sheet.getRangeByName("G${i+3}").setText(HomeScreen.dueList[i]["Due Status"].toString().toUpperCase());
    sheet.getRangeByName("H${i+3}").setText(HomeScreen.dueList[i]["Paid Amount 1"].toString().toUpperCase());
    sheet.getRangeByName("I${i+3}").setText(HomeScreen.dueList[i]["Paid Date 1"].toString().toUpperCase());
    sheet.getRangeByName("J${i+3}").setText(HomeScreen.dueList[i]["Paid Amount 2"].toString().toUpperCase());
    sheet.getRangeByName("K${i+3}").setText(HomeScreen.dueList[i]["Paid Date 2"].toString().toUpperCase());
    sheet.getRangeByName("L${i+3}").setText(HomeScreen.dueList[i]["Paid Amount 3"].toString().toUpperCase());
    sheet.getRangeByName("M${i+3}").setText(HomeScreen.dueList[i]["Paid Date 3"].toString().toUpperCase());
    sheet.getRangeByName("N${i+3}").setText(HomeScreen.dueList[i]["Paid Amount 4"].toString().toUpperCase());
    sheet.getRangeByName("O${i+3}").setText(HomeScreen.dueList[i]["Paid Date 4"].toString().toUpperCase());
    sheet.getRangeByName("P${i+3}").setText(HomeScreen.dueList[i]["Paid Amount 5"].toString().toUpperCase());
    sheet.getRangeByName("Q${i+3}").setText(HomeScreen.dueList[i]["Paid Date 5"].toString().toUpperCase());

    if(HomeScreen.dueList[i]["Due Status"] == "Pending") {
      sheet.getRangeByName("G${i+3}").cellStyle.backColor = red;
    } else if(HomeScreen.dueList[i]["Due Status"] == "Paid") {
      sheet.getRangeByName("G${i+3}").cellStyle.backColor = green;
    } 
  }
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path/Due.xls';

  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open(fileName);
}

Future<void> fetchData(String title) async {
  var databaseRef = FirebaseDatabase.instance.ref();

  if (title == "All Data Excel" || title == "Stock" || title == "Sales") {
    databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Stock');
  } else if (title == "Follow Up") {
    databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Customer');
  } else if (title == "Due") {
    databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Due');
  } else if (title == "Deposit") {
    databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Deposit');
  } else if (title == "Receive") {
    databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Receive');
  } else if (title == "Expense") {
    databaseRef = FirebaseDatabase.instance.ref("Database").child(MyApp.location).child('Expense');
  }

  DatabaseEvent event = await databaseRef.once(); // Added await here
  
  if (event.snapshot.value != null) {
    Map<dynamic, dynamic> map = event.snapshot.value as dynamic;
    List<dynamic> dataList = map.values.toList();
    dataList.sort((a, b) => int.parse(a['Serial Number']).compareTo(int.parse(b['Serial Number'])));

    if (title == "All Data Excel" || title == "Stock" || title == "Sales") {
      HomeScreen.stockList = dataList;
    } else if (title == "Follow Up") {
      HomeScreen.customerList = dataList;
    } else if (title == "Due") {
      HomeScreen.dueList = dataList;
    } else if (title == "Deposit") {
      HomeScreen.depositList = dataList;
    } else if (title == "Receive") {
      HomeScreen.receiveList = dataList;
    } else if (title == "Expense") {
      HomeScreen.expenseList = dataList;
    }
  }
}

Future<void> expenseUpdate(var serial ,String approval) async {
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Expense').child((serial.toString() == "1") ? "01" : serial.toString()).get(); 

    serial = databaseSnapshot.child("Serial Number").value.toString();
    var date = databaseSnapshot.child("Date").value.toString();
    var amount = databaseSnapshot.child("Amount").value.toString();
    var purchase = databaseSnapshot.child("Expense Details").value.toString();

  databaseRef.child("Database").child(MyApp.location).child('Expense').child((serial == "1") ? "01" : serial.toString()).set({
    'Serial Number': serial,
    'Date': date,
    'Amount': amount,
    'Expense Details': purchase,
    'Status': approval
  });
    
}

Future<void> depositUpdate(var serial ,String approval) async {
  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child("Database").child(MyApp.location).child('Deposit').child((serial.toString() == "1") ? "01" : serial.toString()).get(); 

    serial = databaseSnapshot.child("Serial Number").value.toString();
    var date = databaseSnapshot.child("Date").value.toString();
    var amount = databaseSnapshot.child("Amount").value.toString();
    var bank = databaseSnapshot.child("Bank").value.toString();
    var accountNumber = databaseSnapshot.child("Account Number").value.toString();
    var depositor = databaseSnapshot.child("Depositor").value.toString();
    var customerName = databaseSnapshot.child("Customer Name").value.toString();

  databaseRef.child("Database").child(MyApp.location).child('Deposit').child((serial == "1") ? "01" : serial.toString()).set({
    'Serial Number': serial.toString(),
    'Date': date,
    'Amount': amount,
    'Bank': bank,
    'Account Number': accountNumber,
    'Depositor': depositor,
    'Customer Name': customerName,
    'Status' : approval
  });
    
}

void salesModalBottomBarLogic(String task, String stockStatus, String serial, String customer, var context) {
  
  if(task == "invoice") {
    
    if(stockStatus == "Returned") {
      Navigator.pop(context);
      snackbar("Stock is Returned", context);
    } else {
      InvoiceScreen.serial = serial;
      InvoiceScreen.customerName = customer;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceScreen()));
    }

  } else if(task == "disburse") {
    
    if(stockStatus == "Returned") {
      Navigator.pop(context);
      snackbar("Stock is Returned", context);
    } else {
      DisburseScreen.serial = serial;
      DisburseScreen.customerName = customer;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => DisburseScreen()));
    }

  } else if(task == "vehicle") {

    if(stockStatus == "Returned") {
      Navigator.pop(context);
      snackbar("Stock is Returned", context);
    } else {
      if(stockStatus == "Returned") {
        Navigator.pop(context);
        snackbar("Stock is Returned", context);
      } else {
        VehicleNumberScreen.serial = serial;
        VehicleNumberScreen.customerName = customer;
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => VehicleNumberScreen()));
      }
    }

  }

}