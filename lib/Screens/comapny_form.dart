import 'dart:convert';
import 'package:farma_stock/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class FormCompany extends StatefulWidget {
  const FormCompany({Key? key}) : super(key: key);

  @override
  State<FormCompany> createState() => _FormCompanyState();
}

class _FormCompanyState extends State<FormCompany> {
  @override
  void dispose() {
    _nameFocusNode.dispose();
    _directorFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  final TextEditingController nameC = TextEditingController();
  final TextEditingController conta = TextEditingController();
  final TextEditingController imageUrlC = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _directorFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future getData(
    String name,
    String imageurl,
    String contactno,
  ) async {
    final result = await http
        .post(Uri.parse("https://dbmsapi.herokuapp.com/api/company/addCompany"),
            body: jsonEncode({
              "name": name,
              "imageUrl": imageurl,
              "contactNo": contactno,
            }),
            headers: {"Content-Type": "application/json"});
    return json.decode(result.body) as Map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Register Your Company"),
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: const Icon(Icons.arrow_back)),
          backgroundColor: Colors.red),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: formkey,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                buildMovieName(),
                const SizedBox(height: 20),
                buildDirectorName(),
                const SizedBox(height: 20),
                buildImageUrl(),
                const SizedBox(height: 30),
                buildDone()
              ]))),
    );
  }

  Widget buildMovieName() => TextFormField(
      controller: nameC,
      decoration: InputDecoration(
        labelText: 'Company name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      textInputAction: TextInputAction.next,
      focusNode: _nameFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter The Name of Company";
        }
        return null;
      });

  Widget buildDirectorName() => TextFormField(
      controller: conta,
      decoration: InputDecoration(
        labelText: 'Contact No.',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      textInputAction: TextInputAction.next,
      focusNode: _directorFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_directorFocusNode);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter The Contact Number';
        }
        return null;
      });

  Widget buildImageUrl() =>
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(top: 8, right: 10),
            decoration: BoxDecoration(
                border: Border.all(width: 1), color: Colors.white10),
            child: imageUrlC.text.isEmpty
                ? const Center(child: Text('Image Preview'))
                : FittedBox(
                    child: Image.network(
                      imageUrlC.text,
                    ),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        Expanded(
            child: TextFormField(
          focusNode: _imageUrlFocusNode,
          controller: imageUrlC,
          decoration: InputDecoration(
              labelText: 'ImageUrl',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_imageUrlFocusNode);
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter an Image URL.';
            }
            if (!value.startsWith('http') && !value.startsWith('https')) {
              return 'Please enter a valid URL.';
            }
            if (!value.endsWith('.png') &&
                !value.endsWith('.jpg') &&
                !value.endsWith('.jpeg')) {
              return 'Please enter a valid URL.';
            }
            return null;
          },
        ))
      ]);

  Widget buildDone() => Builder(
      builder: (context) => MaterialButton(
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          minWidth: double.infinity,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          height: 50,
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () async {
            String name = nameC.text.toString();
            String contactno = conta.text.toString();
            String imageurl = imageUrlC.text.toString();
            var data = await getData(name, imageurl, contactno);
            if (data != null) {
              if (data["success"] == 1) {
                Fluttertoast.showToast(msg: "DataBase Updated Successfully");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
              } else {
                Fluttertoast.showToast(msg: "Something Went Wrong");
              }
            }
          }));
}
