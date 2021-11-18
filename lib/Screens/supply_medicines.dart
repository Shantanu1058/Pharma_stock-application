import 'dart:convert';
import 'package:farma_stock/Screens/order_tostore_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SupplyMedicines extends StatefulWidget {
  SupplyMedicines({Key? key}) : super(key: key);

  @override
  _SupplyMedicinesState createState() => _SupplyMedicinesState();
}

class _SupplyMedicinesState extends State<SupplyMedicines> {
  List msData = [];
  bool isLoading = false;
  Future getData() async {
    var url = 'https://dbmsapi.herokuapp.com/api/medicine/getStores';
    var response = await http.get(Uri.parse(url));

    Map Data = json.decode(response.body);
    msData = Data["stores"];
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
    }).catchError((e) {
      print(e.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Choose A Store"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : msData.isEmpty
              ? const Center(
                  child: Text("No Medical Stores Available At This Moment"),
                )
              : SafeArea(
                  child: Container(
                  child: ListView.builder(
                      itemCount: msData.length,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderForm(
                                        storeId: msData[index]["_id"]),
                                  ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 55,
                                              height: 55,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.amber,
                                                backgroundImage: NetworkImage(
                                                  msData[index]["imageUrl"],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(msData[index]["name"],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(height: 8),
                                                Text(
                                                    "Contact Number: " +
                                                        msData[index]
                                                            ["contactNo"],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    )),
                                                SizedBox(height: 8),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          )),
                )),
    );
  }
}
