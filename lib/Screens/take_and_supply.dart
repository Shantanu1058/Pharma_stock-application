import 'package:farma_stock/Screens/order_from_company.dart';
import 'package:farma_stock/Screens/supply_medicines.dart';
import 'package:flutter/material.dart';

class TakeAndSupplyMedicines extends StatefulWidget {
  TakeAndSupplyMedicines({Key? key}) : super(key: key);

  @override
  _TakeAndSupplyMedicinesState createState() => _TakeAndSupplyMedicinesState();
}

class _TakeAndSupplyMedicinesState extends State<TakeAndSupplyMedicines> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Choose An Option"),
      ),
      body: SafeArea(
          child: Column(children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupplyMedicines(),
                ));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(20)),
            child: const ListTile(
              leading: SizedBox(
                width: 55,
                height: 55,
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                  backgroundImage: NetworkImage(
                      "https://image.shutterstock.com/image-vector/pharmacy-store-concept-vector-infographic-260nw-1388104772.jpg",
                      scale: 0.03),
                ),
              ),
              title: Text("Supply Medicines To Stores"),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderFromCompany(),
                ));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(20)),
            child: const ListTile(
              leading: SizedBox(
                width: 55,
                height: 55,
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6-GfK5oRI4-FMH_Fq3c1SZK6ToKd_ZvJQiw&usqp=CAU"),
                ),
              ),
              title: Text("Order Medicines From Company"),
            ),
          ),
        ),
      ])),
    );
  }
}
