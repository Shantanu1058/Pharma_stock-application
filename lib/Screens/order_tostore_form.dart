import 'package:farma_stock/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class OrderForm extends StatefulWidget {
  final String storeId;
  OrderForm({Key? key, required this.storeId}) : super(key: key);

  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  Map msData = {};
  bool isLoading = false;
  bool isPressed = false;
  bool loading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final _nameFocusNode = FocusNode();
  // final _directorFocusNode = FocusNode();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Future getData(String name) async {
    var url = 'https://dbmsapi.herokuapp.com/api/medicine/searchMedicine';
    var response = await http.post(Uri.parse(url),
        body: json.encode({"name": name}),
        headers: {"Content-Type": "application/json"});

    Map Data = json.decode(response.body);
    print(Data);
    if (Data["success"] == 1) {
      msData = Data["medicine"];
    }
  }

  Future supplyMedicine(String name, String quantity) async {
    var url =
        'https://dbmsapi.herokuapp.com/api/medicine/supplyMedicineToStore';
    var response = await http.post(Uri.parse(url),
        body: json.encode({
          "name": name,
          "medicineId": msData["_id"],
          "storeId": widget.storeId,
          "quantity": quantity
        }),
        headers: {"Content-Type": "application/json"});

    Map Data = json.decode(response.body);
    print(Data);
    if (Data["success"] == 1) {
      Fluttertoast.showToast(msg: "Order Placed");
    } else {
      Fluttertoast.showToast(msg: "Something Went Wrong");
    }
  }

  Widget buildDone() => Builder(
      builder: (context) => loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : MaterialButton(
              child: const Text(
                'Supply To Store',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              height: 50,
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () async {
                String name = msData["name"];
                String quantity = quantityController.text.toString();
                setState(() {
                  loading = true;
                });
                supplyMedicine(name, quantity).then((_) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                });
              }));
  Widget searchButton() => Builder(
      builder: (context) => MaterialButton(
          child: const Text(
            'Search',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          minWidth: double.infinity,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          height: 50,
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () async {
            setState(() {
              isPressed = true;
              isLoading = true;
            });
            getData(nameController.text).then((_) {
              setState(() {
                isLoading = false;
              });
            });
          }));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildDone(),
      ),
      appBar: AppBar(
          title: const Text("Order Details"), backgroundColor: Colors.red),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: formkey,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                buildMovieName(),
                const SizedBox(height: 20),
                searchButton(),
                const SizedBox(height: 20),
                isPressed
                    ? isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Medicine Details",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(
                                  "Name: ${msData.isEmpty ? "Not Found" : msData["name"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "MRP: ${msData.isEmpty ? "Not Found" : msData["mrp"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Quantity: ${msData.isEmpty ? "Not Found" : msData["quantity"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Expiry Date: ${msData.isEmpty ? "Not Found" : msData["expiryDate"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                msData.isEmpty ? Container() : quantity(),
              ]))),
    );
  }

  Widget buildMovieName() => TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Enter The Name of Medicine',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      textInputAction: TextInputAction.next,
      focusNode: _nameFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter The Name of Medicine";
        }
        return null;
      });
  Widget quantity() => TextFormField(
      controller: quantityController,
      decoration: InputDecoration(
        labelText: 'Enter The Quantity',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: _nameFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter The Name of Medicine";
        } else if (int.parse(value) > int.parse(msData["quantity"])) {
          return "Quantity Exceeded";
        }
        return null;
      });

  // Widget buildDirectorName() => TextFormField(
  //     controller: contactController,
  //     decoration: InputDecoration(
  //       labelText: 'Contact No.',
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  //     ),
  //     textInputAction: TextInputAction.next,
  //     keyboardType: TextInputType.phone,
  //     focusNode: _directorFocusNode,
  //     onFieldSubmitted: (_) {
  //       FocusScope.of(context).requestFocus(_directorFocusNode);
  //     },
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         return 'Please Enter The Contact Number';
  //       }
  //       return null;
  //     });
}
