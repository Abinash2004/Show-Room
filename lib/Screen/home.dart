import 'package:flutter/material.dart';
import 'package:show_room/elements/widgets.dart';
import 'package:show_room/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static List<dynamic> stockList = [];
  static List<dynamic> customerList = [];
  static List<dynamic> dueList = [];
  static List<dynamic> depositList = [];
  static List<dynamic> receiveList = [];
  static List<dynamic> expenseList = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? loc = "Aska";
  @override
  Widget build(BuildContext context) {
    
    final List<String> locationList = ["Aska", "Baliguda", "Bhanjanagar", "Mohana", "Surada"];
    var screen = MediaQuery.sizeOf(context);
    
    var customerColor = Color.fromARGB(255, 25, 35, 45);
    var dueColor = Color.fromARGB(255, 30, 25, 45);
    var stockColor = Color.fromARGB(255, 25, 25, 25);

    return Scaffold(
      
      backgroundColor: Color(0xff0b090a),
      
      appBar: AppBar(
        
        toolbarHeight: 75,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white60,height: 0.25)),
        
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Text("Dashboard", style: TextStyle(
              color: Colors.white60,
              fontSize: 25,
              fontWeight: FontWeight.w600
            )),
            Text(MyApp.location, style: TextStyle(
              color: Colors.white38,
              fontSize: 15,
              fontWeight: FontWeight.w300
            )),
          ],
        ),

        actions: [
          (MyApp.user == "Admin") ? homeInputContainer(
              DropdownButton<String>(
                dropdownColor: Color.fromARGB(255, 15, 15, 15),
                value: loc,
                items: locationList.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,style: textStyle()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    HomeScreen.stockList.clear();
                    HomeScreen.dueList.clear();
                    HomeScreen.customerList.clear();
                    HomeScreen.depositList.clear();
                    loc = newValue.toString();
                    MyApp.location = newValue.toString();
                  });
                },
              ),    
            ) : SizedBox(),
            SizedBox(width: screen.width*0.025)
        ],
        
        backgroundColor: Color(0xff0b090a),
        
        automaticallyImplyLeading: false,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    
                    homeContainer("Follow Up",screen,screen.width * 0.45, customerColor,context),
                    
                    SizedBox(width: screen.height * 0.02),

                    homeContainer("Due",screen,screen.width * 0.45, customerColor,context)
                  ],
                ),

                SizedBox(height: screen.height * 0.03),
                
                (MyApp.user == "Admin") ? downloadContainer("All Data Excel",stockColor,screen.width * 0.95,context) : SizedBox(),
            
                (MyApp.user == "Admin") ? SizedBox(height: screen.height * 0.03) : SizedBox(),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    homeContainer("Stock", screen, screen.width * 0.45, stockColor, context),

                    SizedBox(width: screen.width * 0.05),
                    
                    homeContainer("Sales", screen, screen.width * 0.45, stockColor, context),

                  ],
                ),
                
                SizedBox(height: screen.height * 0.03),

                homeContainer("Expense",screen,screen.width * 0.95, dueColor,context),
                
                SizedBox(height: screen.height * 0.03),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    homeContainer("Deposit",screen,screen.width * 0.45, dueColor,context),
                    
                    SizedBox(width: screen.width * 0.05),
                    
                    homeContainer("Receive",screen,screen.width * 0.45, dueColor,context),
                  ],
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}