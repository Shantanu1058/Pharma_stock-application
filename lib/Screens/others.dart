import 'package:farma_stock/Screens/bills_screen.dart';
import 'package:farma_stock/Screens/employee_screen.dart';
import 'package:flutter/material.dart';

class Others extends StatefulWidget {
  const Others({Key? key}) : super(key: key);

  @override
  _OthersState createState() => _OthersState();
}

class _OthersState extends State<Others> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Others"),
          backgroundColor: Colors.amber,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Bills",
                icon: Icon(Icons.calculate),
              ),
              Tab(text: "Employies", icon: Icon(Icons.emoji_people))
            ],
          ),
        ),
        body: TabBarView(
          children: [BillScreen(), EmployeeScreen()],
        ),
      ),
    );
  }
}
