import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Models/tenant_menu_model.dart';
import 'package:gtc_mobile/Services/tenant_service.dart';
import 'package:gtc_mobile/Models/tenant_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MenusWidget extends StatefulWidget {
  @override
  _MenusWidgetState createState() => _MenusWidgetState();
}

class _MenusWidgetState extends State<MenusWidget> {
  Future<List<TenantModel>>? _futureTenantList;
  Future<List<TenantMenuModel>>? _futureTenantMenuList;

  void loadTenantList() {
    setState(() {
      _futureTenantList = TenantService.getTenantList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadTenantList();
  }

  Map<String, int> _menuQuantities = {
    'Rasya': 0,
    'Madam': 0,
    'Idon': 0,
    'Lili': 0,
  };

  List<Map<String, dynamic>> menuItems = [
    {
      'name': 'Nasi Goreng',
      'imagePath': 'assets/tenantListImages/1.jpg',
      'price': 30000
    },
    {
      'name': 'Mi Goreng',
      'imagePath': 'assets/tenantListImages/2.jpg',
      'price': 25000
    },
    {
      'name': 'Bakso',
      'imagePath': 'assets/tenantListImages/3.jpg',
      'price': 20000
    },
    {
      'name': 'Bakso Udang',
      'imagePath': 'assets/tenantListImages/4.jpg',
      'price': 35000
    },
    {
      'name': 'Jus',
      'imagePath': 'assets/tenantListImages/5.jpg',
      'price': 15000
    },
    {
      'name': 'Zuppa Soup',
      'imagePath': 'assets/tenantListImages/6.jpg',
      'price': 28000
    },
    {
      'name': 'Batagor',
      'imagePath': 'assets/tenantListImages/7.jpg',
      'price': 18000
    },
    {
      'name': 'Kwetiau Goreng',
      'imagePath': 'assets/tenantListImages/8.jpg',
      'price': 22000
    },
  ];

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
              for (var menuItem in menuItems)
                _buildMenuItem(menuName, menuItem),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String menuName, Map<String, dynamic> menuItem) {
    final uniqueKey = '${menuName}-${menuItem['name']}';

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
                menuItem['imagePath'] ?? '',
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
                  menuItem['name'] ?? '',
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
                  "Rp${menuItem['price'] ?? 0}", // Display the price
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
