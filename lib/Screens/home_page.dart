import 'package:farma_stock/Screens/company_screen.dart';
import 'package:farma_stock/Screens/medical_store.dart';
import 'package:farma_stock/Screens/medicines.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'others.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      // BottomNavigationBar(items: const [
      //   BottomNavigationBarItem(
      //     icon: Icon(Icons.home),
      //     label: 'Company',
      //     backgroundColor: Colors.amber
      //   ),
      //   BottomNavigationBarItem(
      //     icon: Icon(Icons.store_mall_directory),
      //     label: 'Medical Stores',
      //      backgroundColor: Colors.amber
      //   ),
      //   BottomNavigationBarItem(
      //     icon: Icon(Icons.medication),
      //     label: 'Medicines',
      //     backgroundColor: Colors.amber
      //   ),
      //   BottomNavigationBarItem(
      //     icon: Icon(Icons.more_horiz),
      //     label: 'Others',
      //     backgroundColor: Colors.amber
      //   )
      // ],) ,

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : selectedScreen(),
    );
  }

  Widget selectedScreen() {
    switch (index) {
      case 1:
        return const MedicalStore();
      case 2:
        return const Medicines();
      case 3:
        return const Others();
      default:
        return const CompanyScreen();
    }
  }

  Widget buildBottomNavigationBar() {
    return BottomNavyBar(
      selectedIndex: index,
      onItemSelected: (index) {
        setState(() {
          this.index = index;
        });
      },
      items: [
        BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Company'),
            activeColor: Colors.amber,
            inactiveColor: Colors.black),
        BottomNavyBarItem(
            icon: const Icon(Icons.store_mall_directory),
            title: const Text('Stores'),
            activeColor: Colors.amber,
            inactiveColor: Colors.black),
        BottomNavyBarItem(
            icon: const Icon(Icons.medication),
            title: const Text('Medicines'),
            activeColor: Colors.amber,
            inactiveColor: Colors.black),
        BottomNavyBarItem(
            icon: const Icon(Icons.more_horiz),
            title: const Text('Others'),
            activeColor: Colors.amber,
            inactiveColor: Colors.black)
      ],
    );
  }
}
