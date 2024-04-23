import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenusWidget extends StatefulWidget {
  @override
  _MenusWidgetState createState() => _MenusWidgetState();
}

class _MenusWidgetState extends State<MenusWidget> {
  Map<String, int> _menuQuantities = {
    'Rasya': 0,
    'Madam': 0,
    'Idon': 0,
    'Lili': 0,
  };

  void _incrementQuantity(String menuName) {
    setState(() {
      _menuQuantities[menuName] = (_menuQuantities[menuName] ?? 0) + 1;
    });
  }

  void _decrementQuantity(String menuName) {
    setState(() {
      if (_menuQuantities[menuName] != null && _menuQuantities[menuName]! > 0) {
        _menuQuantities[menuName] = (_menuQuantities[menuName]! - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12, top: 10),
                child: Text(
                  "Daftar Menu",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(211, 36, 43, 1),
                  ),
                ),
              )
            ],
          ),
        ),
        for (var menuName in _menuQuantities.keys) _buildMenu(menuName),
      ],
    );
  }

  Widget _buildMenu(String menuName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 8, bottom: 10),
          child: Text(
            menuName,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(126, 0, 0, 1),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 1; i <= 8; i++) _buildMenuItem(menuName, i),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String menuName, int index) {
    final uniqueKey = '$menuName-$index';

    return Container(
      key: Key(uniqueKey),
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      height: 120,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/tenantListImages/1.jpg',
                height: 100,
                width: 100,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 5, top: 30),
                child: Text(
                  "Nasi Goreng",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(202, 37, 37, 1),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 5),
                child: Text(
                  "Rp30,000",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline,
                        color: Color.fromRGBO(211, 36, 43, 1)),
                    onPressed: () => _incrementQuantity(uniqueKey),
                  ),
                  Text(
                    (_menuQuantities[uniqueKey] ?? 0).toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Color.fromRGBO(211, 36, 43, 1),
                    ),
                    onPressed: () => _decrementQuantity(uniqueKey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
