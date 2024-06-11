import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:gtc_mobile/Services/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import '../Pages/LandPage.dart';
import '../Pages/MenusPage.dart';
import '../Pages/OrdersPage.dart';
import '../Pages/CheckoutPage.dart';

class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  int pageIndex = 0;
  int cartItemCount = 0;
  late PageController pageController;

  Future<void> _updateCartItemCount() async {
    int count = await _getCartItemCount();
    setState(() {
      cartItemCount = count;
    });
  }

  Future<int> _getCartItemCount() async {
    final db = await DatabaseHelper.instance.database;
    final countResult = await db.rawQuery('SELECT COUNT(*) FROM cart_items');
    int count = Sqflite.firstIntValue(countResult) ?? 0;
    return count;
  }

  void _showEmptyCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keranjang Kosong!'),
          content: Text('Pilihlah suatu menu terlebih dahulu'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
    _updateCartItemCount();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        children: [
          LandPage(),
          MenusPage(),
          CheckoutPage(),
          OrdersPage(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [
          Icons.home_outlined,
          Icons.fastfood_outlined,
          Icons.shopping_cart_checkout_outlined,
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
        onTap: (index) async {
          if (index == 2) {
            // CheckoutPage index is 2
            final cartItemCount = await _getCartItemCount();
            if (cartItemCount == 0) {
              _showEmptyCartDialog(context);
              return; // Return early to prevent navigation
            }
          }

          setState(() {
            pageIndex = index;
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
      ),
    );
  }
}
