import 'dart:convert';

import 'package:farma_stock/Screens/take_and_supply.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Medicines extends StatefulWidget {
  const Medicines({Key? key}) : super(key: key);

  @override
  State<Medicines> createState() => _MedicinesState();
}

class _MedicinesState extends State<Medicines> {
  bool isLoading = false;
  List medicineData = [];
  Future getData() async {
    var url = 'https://dbmsapi.herokuapp.com/api/medicine/getMedicines';
    var response = await http.get(Uri.parse(url));

    Map Data = json.decode(response.body);
    medicineData = Data["medicines"];
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getData().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TakeAndSupplyMedicines(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Medicines"),
        backgroundColor: Colors.amber,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : medicineData.isEmpty
              ? const Center(
                  child: Text("No Medicines Available At This Moment"),
                )
              : ListView.builder(
                  itemCount: medicineData.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        child: GestureDetector(
                          onTap: () {},
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 55,
                                          height: 55,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.amber,
                                            backgroundImage: NetworkImage(
                                              medicineData[index]["imageUrl"],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(medicineData[index]["name"],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 8),
                                            Text(
                                                "Expiry Date: " +
                                                    medicineData[index]
                                                        ["expiryDate"],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Text("Quantity :",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    medicineData[index]
                                                        ["quantity"],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                            Row(
                                              children: [
                                                const Text("MRP :",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(medicineData[index]["mrp"],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ),
                      )),
    );
  }
}
