import 'package:admin_app/sceen/nav_bar/category_page.dart';
import 'package:admin_app/sceen/nav_bar/home_page.dart';
import 'package:admin_app/sceen/nav_bar/order_page.dart';
import 'package:admin_app/sceen/nav_bar/product_page.dart';
import 'package:admin_app/sceen/nav_bar/profile_page.dart';
import 'package:flutter/material.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  List<Widget> pages = [
    HomePage(),
    CategoryPage(),
    OrderPage(),
    ProductPage(),
    ProfilePage()
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: pages[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.blue,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: "Category"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shop_two_outlined), label: "Order"),
            BottomNavigationBarItem(
                icon: Icon(Icons.production_quantity_limits_outlined),
                label: "product"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
          ]),
    );
  }
}
