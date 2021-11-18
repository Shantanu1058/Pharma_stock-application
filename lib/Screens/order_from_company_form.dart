import 'package:farma_stock/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class OrderFromCompanyForm extends StatefulWidget {
  final String companyId;
  OrderFromCompanyForm({Key? key, required this.companyId}) : super(key: key);

  @override
  _OrderFromCompanyFormState createState() => _OrderFromCompanyFormState();
}

class _OrderFromCompanyFormState extends State<OrderFromCompanyForm> {
  Map msData = {};
  bool isLoading = false;
  bool isPressed = false;
  bool loading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
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

  Future orderMedicine(String name, String quantity) async {
    var url =
        'https://dbmsapi.herokuapp.com/api/company/takeMedicineFromCompany';
    var response = await http.post(Uri.parse(url),
        body: json.encode({
          "name": name,
          "companyId": widget.companyId,
          "quantity": quantity
        }),
        headers: {"Content-Type": "application/json"});

    Map Data = json.decode(response.body);
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
                'Order From Company',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              height: 50,
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () async {
                String name = nameController.text.toString();
                String quantity = quantityController.text.toString();
                setState(() {
                  loading = true;
                });
                orderMedicine(name, quantity).then((_) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildMovieName(),
                    const SizedBox(height: 20),
                    quantity()
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
        FocusScope.of(context).requestFocus(_quantityFocusNode);
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
      focusNode: _quantityFocusNode,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter The Name of Medicine";
        }
        return null;
      });
}
