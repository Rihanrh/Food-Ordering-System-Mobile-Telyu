import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../Pages/LandPage.dart';
import '../Pages/MenusPage.dart';
import '../Pages/OrdersPage.dart';

class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({super.key});

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  int pageIndex = 0;

  List<Widget> pages = [
    MenusPage(),
    LandPage(),
    OrdersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        child: AnimatedBottomNavigationBar(
          icons: [
            Icons.fastfood_outlined,
            Icons.home_outlined,
            Icons.list_alt_outlined,
          ],
          inactiveColor: Color.fromRGBO(116, 116, 116, 1),
          activeColor: Color.fromRGBO(211, 36, 43, 1),
          gapLocation: GapLocation.none,
          activeIndex: pageIndex,
          leftCornerRadius: 10,
          iconSize: 30,
          rightCornerRadius: 0,
          elevation: 0,
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
