import 'dart:convert';
import 'package:farma_stock/Screens/comapny_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  List companiesData = [];
  bool isLoading = false;
  Future getData() async {
    var url = 'https://dbmsapi.herokuapp.com/api/company/getCompanies';
    var response = await http.get(Uri.parse(url));

    Map Data = json.decode(response.body);
    companiesData = Data["companies"];
  }

  Future deleteCompany(String id) async {
    var url = 'https://dbmsapi.herokuapp.com/api/company/$id';
    var response = await http.delete(Uri.parse(url));
    Map data = json.decode(response.body);
    if (data["success"] == 1) {
      Fluttertoast.showToast(msg: "Company Deleted Successfully");
    } else {
      Fluttertoast.showToast(msg: "Something Went Wrong");
    }
  }

  Widget deleteItem() {
    return Container(
      padding: const EdgeInsets.only(right: 30),
      alignment: Alignment.centerRight,
      child: const Icon(Icons.delete),
      color: Colors.red,
    );
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const FormCompany()));
        },
      ),
      appBar: AppBar(
        title: const Text("Companies"),
        backgroundColor: Colors.amber,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : companiesData.isEmpty
              ? const Center(
                  child: Text("No Companies Available At This Moment"),
                )
              : RefreshIndicator(
                  onRefresh: getData,
                  child: ListView.builder(
                      itemCount: companiesData.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Dismissible(
                            key: Key(companiesData[index]["name"]),
                            onDismissed: (direction) {
                              deleteCompany(companiesData[index]["_id"]);
                            },
                            background: deleteItem(),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.of(context).pushReplacement(
                                  //     MaterialPageRoute(
                                  //         builder: (context) => CompanyDetails(
                                  //             companiesData[index]["name"],
                                  //             index)));
                                },
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
                                              Container(
                                                width: 55,
                                                height: 55,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.amber,
                                                  backgroundImage: NetworkImage(
                                                    companiesData[index]
                                                        ["imageUrl"],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      companiesData[index]
                                                          ["name"],
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                      "ContactNo: " +
                                                          companiesData[index]
                                                              ["contactNo"],
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
                              ),
                            ),
                          )),
                ),
    );
  }
}
