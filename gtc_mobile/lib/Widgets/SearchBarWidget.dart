import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Services/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'CheckoutWidget.dart';

class SearchBarWidget extends StatefulWidget {
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _updateCartItemCount();
  }

  Future<void> _updateCartItemCount() async {
    int count = await _getCartItemCount();
    setState(() {
      cartItemCount = count;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Cari Kebutuhanmu",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_checkout_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () async {
                  int cartItemCount = await _getCartItemCount();
                  if (cartItemCount > 0) {
                    CheckoutModal.show(context);
                  } else {
                    _showEmptyCartDialog(context);
                  }
                },
              ),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$cartItemCount',
                    style: GoogleFonts.poppins(
                      color: Color.fromRGBO(202, 37, 37, 1),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
}
