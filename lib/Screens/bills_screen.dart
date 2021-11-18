import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BillScreen extends StatefulWidget {
  BillScreen({Key? key}) : super(key: key);

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  List billsData = [];
  bool isLoading = false;
  Future getData() async {
    var url = 'https://dbmsapi.herokuapp.com/api/bill/getBills';
    var response = await http.get(Uri.parse(url));

    Map Data = json.decode(response.body);
    billsData = Data["bills"];
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

  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : billsData.isEmpty
            ? const Center(
                child: Text("No Bills Available At This Moment"),
              )
            : RefreshIndicator(
                onRefresh: getData,
                child: ListView.builder(
                    itemCount: billsData.length,
                    itemBuilder: (BuildContext context, int index) => Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(billsData[index]["storeName"],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 8),
                                            Text(
                                                "Total Amount: " +
                                                    billsData[index]
                                                        ["totalAmount"],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                )),
                                            const SizedBox(height: 8),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        )),
              );
  }
}
