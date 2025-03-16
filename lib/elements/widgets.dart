// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:show_room/Screen/After%20Sales/invoice.dart';
import 'package:show_room/Screen/After%20Sales/vehicle_number.dart';
import 'package:show_room/Screen/Customer/add_customer.dart';
import 'package:show_room/Screen/Customer/view_customer.dart';
import 'package:show_room/Screen/Due/add_due.dart';
import 'package:show_room/Screen/Due/view_due.dart';
import 'package:show_room/Screen/Expense/add_expense.dart';
import 'package:show_room/Screen/Expense/view_expense.dart';
import 'package:show_room/Screen/Deposit/add_deposit.dart';
import 'package:show_room/Screen/Deposit/view_deposit.dart';
import 'package:show_room/Screen/Receive/add_receive.dart';
import 'package:show_room/Screen/Receive/view_receive.dart';
import 'package:show_room/Screen/Sales/view_sales.dart';
import 'package:show_room/Screen/Stock/add_stock.dart';
import 'package:show_room/Screen/Stock/modify_stock.dart';
import 'package:show_room/Screen/Stock/view_stock.dart';
import 'package:show_room/elements/functions.dart';

// --------------------------Global Widgets-----------------------------

var bgcolor = Color(0xff0b090a);
var accentColor = Color.fromARGB(255, 25, 25, 25);

TextStyle textStyle() {
  return TextStyle(
    fontSize: 18,
    color: Colors.white54,
    fontWeight: FontWeight.w500
  );
}

ButtonStyle buttonStyle(var color) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) => states.contains(WidgetState.pressed) ? null : color),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(var text, var context) {
  return  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: const Color.fromARGB(255, 150, 150, 150),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
      content: Center(
        child: Text(text,
          style: TextStyle(
            color: Color.fromARGB(255, 25, 25, 25),
            fontSize: 22,
            fontWeight: FontWeight.w800
          ),
        ),
      )
    )
  );
}

Widget appBarInputContainer(var widget) {
  return Padding(
    padding: const EdgeInsets.only(right: 10.0),
    child: Container(
      height: 40,
      width: 130,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 25, 25, 25),
        borderRadius: BorderRadius.circular(30), // Circular radius
      ),
      child: Align(
        alignment: Alignment.center,
        child: widget
      )
    ),
  );
}

Widget customerListTitle(String text) {
  return Text(text, 
    style: TextStyle(
      color: Colors.white60,
      fontSize: 15,
      fontWeight: FontWeight.w500
    )
  );
}

Widget customerListSubTitle(String text) {
  return Text(text, 
    style: TextStyle(
      color: Colors.white30,
      fontSize: 15,
      fontWeight: FontWeight.w500
    )
  );
}
// ----------------------------Login Screen------------------------------

Pinput pinPutOTP(var otpCode) {
  final defaultPinTheme = PinTheme(
    width: 45,
    height: 45,
    textStyle: TextStyle(
      color: Colors.white70,
      fontSize: 25,
      fontWeight: FontWeight.w900
    ),
    decoration: BoxDecoration(
      color: accentColor,
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: Colors.grey, width: 2.5),
    borderRadius: BorderRadius.circular(10),
  );

  return Pinput(
    length: 4,
    defaultPinTheme: defaultPinTheme,
    focusedPinTheme: focusedPinTheme,
    controller: otpCode,
    showCursor: true,
  );
}

// ----------------------------Home Screen-------------------------------

Widget homeContainer(var title, var screen, var size, var color, var context) {
  return SizedBox(
    height: 50,
    width: size,
    child:ElevatedButton(
      style: buttonStyle(color),
      onPressed: () async {
        if(title == "Stock") {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const ViewStockScreen()));
        } else if(title == "Sales") {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const ViewSalesScreen()));
        } else if(title == "Modify Stock") {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const ModifyStockScreen()));
        } else if(title == "Follow Up") {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const ViewCustomerScreen()));
        } else if(title == "Due") {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const ViewDueScreen()));
        } else if(title == "Invoice") {
          clearStockData();
          Navigator.push(context,MaterialPageRoute(builder: (context) => const InvoiceScreen()));
        } else if(title == "Vehicle Number") {
          clearStockData();
          Navigator.push(context,MaterialPageRoute(builder: (context) => const VehicleNumberScreen()));
        } else if(title == "Deposit") {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const ViewDepositScreen()));
        } else if(title == "Receive") {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const ViewReceiveScreen()));
        } else if(title == "Expense") {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const ViewExpenseScreen()));
        }
      },
      child: Text(title,
      style: TextStyle(
        color: Colors.white60,
        fontSize: screen.width * 0.04,
        fontWeight: FontWeight.w400
      ),)
    )
  );
}

Widget downloadContainer(String title, Color color, double size, BuildContext context) {
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  return SizedBox(
    height: 50,
    width: size,
    child: ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, child) {
        return ElevatedButton(
          style: buttonStyle(color),
          onPressed: () async {
            isLoading.value = true; 
            await fetchData(title);

            if (title == "All Data Excel") {
              await createStockExcel();
            }

            isLoading.value = false; // Hide loader
          },
          child: loading ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ) : Text( title,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    ),
  );
}

Widget downloadButton(String title) {
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  return ValueListenableBuilder<bool>(
    valueListenable: isLoading,
    builder: (context, loading, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          FloatingActionButton(
            heroTag: "New",
            backgroundColor: Color.fromARGB(255, 25, 35, 45),
            onPressed: () async {
              if(title == "Follow Up") {
                await getCustomerSerialNumber();
                Navigator.push(context,MaterialPageRoute(builder: (context) => const AddCustomerScreen()));
              } else if(title == "Due") {
                await getDueSerialNumber();
                Navigator.push(context,MaterialPageRoute(builder: (context) => const AddDueScreen()));
              } else if(title == "Stock") {
                await getStockSerialNumber();
                Navigator.push(context,MaterialPageRoute(builder: (context) => const AddStockScreen()));
              } else if(title == "Sales") {
                Navigator.push(context,MaterialPageRoute(builder: (context) => const ModifyStockScreen()));
              } else if(title == "Deposit") {
                await getDepositSerialNumber();
                Navigator.push(context,MaterialPageRoute(builder: (context) => const DepositScreen()));
              } else if(title == "Receive") {
                await getReceiveSerialNumber();
                Navigator.push(context,MaterialPageRoute(builder: (context) => const ReceiveScreen()));
              } else if(title == "Expense") {
                await getExpenseSerialNumber();
                Navigator.push(context,MaterialPageRoute(builder: (context) => const AddExpenseScreen()));
              }
            },
            child: Icon(Icons.add_rounded,color: Colors.white60, size: 30)
          ),

          SizedBox(height: 10),

          FloatingActionButton(
            heroTag: "Excel",
            backgroundColor: Color.fromARGB(255, 30, 25, 45),
            onPressed: () async {
              isLoading.value = true; 
              await fetchData(title);
            
              if (title == "Stock") {
                await createViewStockExcel();
              } else if (title == "Sales") {
                await createViewSalesExcel();
              } else if (title == "Follow Up") {
                await createCustomerExcel();
              } else if (title == "Due") {
                await createDueExcel();
              } else if (title == "Deposit") {
                await createDepositExcel();
              } else if (title == "Receive") {
                await createReceiveExcel();
              } else if (title == "Expense") {
                await createExpenseExcel();
              }
            
              isLoading.value = false; // Hide loader
            },
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(Icons.upload_file_rounded,color: Colors.white60, size: 30)
          ),
        ],
      );
    },
  );
}

// ----------------------------Add Stock Screen--------------------------

Widget inputContainer(var widget) {
  return Container(
    height: 60,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 25, 25, 25),
      borderRadius: BorderRadius.circular(30), // Circular radius
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: widget,
      )
    )
  );
}

Widget homeInputContainer(var widget) {
  return Container(
    height: 50,
    width: 160,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 25, 25, 25),
      borderRadius: BorderRadius.circular(30), // Circular radius
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: widget,
      )
    )
  );
}

Widget textField(var text,var controller, bool isDigit) {

  var defaultBorder = const OutlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.solid, width: 0),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      );

  return TextFormField(
    controller: controller,
    keyboardType: isDigit ? TextInputType.number : TextInputType.text,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.w600 ),

    decoration: InputDecoration(
      
      contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left: 20),
      filled: true,
      fillColor: accentColor,
      labelText: text,
      labelStyle:  textStyle(),
      floatingLabelStyle: TextStyle(color: Colors.white38, fontSize: 20),
      
      enabledBorder: defaultBorder,
      errorBorder: defaultBorder,
      focusedErrorBorder: defaultBorder,
      focusedBorder: defaultBorder,
    ), 
  );
}

Widget stockTextField(var controller, var fun) {

  var defaultBorder = const OutlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.solid, width: 0),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      );

  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.w600 ),

    decoration: InputDecoration(
      
      contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left: 20),
      filled: true,
      fillColor: accentColor,
      labelText: "Stock Serial Number",
      labelStyle:  textStyle(),
      floatingLabelStyle: TextStyle(color: Colors.white38, fontSize: 20),
      suffixIcon: IconButton(onPressed: fun, icon: Icon(Icons.search_rounded, color: Colors.white60, size: 25)),
      
      enabledBorder: defaultBorder,
      errorBorder: defaultBorder,
      focusedErrorBorder: defaultBorder,
      focusedBorder: defaultBorder,
    ), 
  );
}