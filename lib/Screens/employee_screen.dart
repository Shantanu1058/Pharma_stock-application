import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeScreen extends StatefulWidget {
  EmployeeScreen({Key? key}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  List employeeData = [];
  bool isLoading = false;
  Future getData() async {
    var url = 'https://dbmsapi.herokuapp.com/api/employee/getEmployees';
    var response = await http.get(Uri.parse(url));

    Map Data = json.decode(response.body);
    employeeData = Data["employees"];
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
        : employeeData.isEmpty
            ? const Center(
                child: Text("No Employee Available At This Moment"),
              )
            : RefreshIndicator(
                onRefresh: getData,
                child: ListView.builder(
                    itemCount: employeeData.length,
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
                                            Text(employeeData[index]["name"],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 8),
                                            Text(
                                                "Role: " +
                                                    employeeData[index]["role"],
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
