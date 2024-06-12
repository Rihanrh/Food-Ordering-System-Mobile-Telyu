import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Models/TenantMenuModel.dart';
import 'package:gtc_mobile/Services/TenantService.dart';
import 'package:gtc_mobile/Models/TenantModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gtc_mobile/Models/CartItemModel.dart';
import 'package:gtc_mobile/Services/DatabaseHelper.dart';

class MenusWidget extends StatefulWidget {
  @override
  _MenusWidgetState createState() => _MenusWidgetState();
}

class _MenusWidgetState extends State<MenusWidget> {
  Future<List<TenantModel>>? _futureTenantList;

  void loadTenantList() {
    if (_futureTenantList == null) {
      setState(() {
        _futureTenantList = TenantService.getTenantList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadTenantList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TenantModel>>(
      future: _futureTenantList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 22, top: 8, bottom: 10),
                      child: Text(
                        snapshot.data![index].nama_tenant,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(126, 0, 0, 1),
                        ),
                      ),
                    ),
                    TenantMenuCard(tenant: snapshot.data![index]),
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: loadTenantList,
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class TenantMenuCard extends StatefulWidget {
  const TenantMenuCard({
    super.key,
    required this.tenant,
  });

  final TenantModel tenant;

  @override
  State<TenantMenuCard> createState() => _TenantMenuCardState();
}

class _TenantMenuCardState extends State<TenantMenuCard> {
  Future<List<TenantMenuModel>>? _futureTenantMenuList;

  void loadTenantMenuList(int tenantId) {
    if (_futureTenantMenuList == null) {
      setState(() {
        _futureTenantMenuList = TenantService.getTenantMenuList(tenantId);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadTenantMenuList(widget.tenant.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TenantMenuModel>>(
      future: _futureTenantMenuList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Container(
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
                          child: Image.network(
                            dotenv.env['API_URL']! + "/file/" + item.fotoProduk,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 5, top: 30),
                            child: Text(
                              item.namaProduk,
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
                              item.hargaProduk.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          CartItemCount(
                            tenant: widget.tenant,
                            menu: item,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class CartItemCount extends StatefulWidget {
  final TenantModel tenant;
  final TenantMenuModel menu;

  const CartItemCount({
    super.key,
    required this.tenant,
    required this.menu,
  });

  @override
  State<CartItemCount> createState() => _CartItemCountState();
}

class _CartItemCountState extends State<CartItemCount> {
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    _getQuantityFromDatabase();
  }

  Future<void> _getQuantityFromDatabase() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'cart_items',
      where: 'idTenant = ? AND idMenu = ?',
      whereArgs: [widget.tenant.id, widget.menu.id],
    );
    setState(() {
      quantity = maps.isNotEmpty ? maps.first['quantity'] as int : 0;
    });
  }

  Future<void> addToCart() async {
    final db = await DatabaseHelper.instance.database;

    // Check if there are any items in the cart
    final existingItems = await db.query('cart_items');
    if (existingItems.isNotEmpty) {
      // Get the idTenant of the first item
      final firstItemTenantId = existingItems.first['idTenant'] as int;
      // Compare with the current item's idTenant
      if (firstItemTenantId != widget.tenant.id) {
        // Show AlertDialog if the tenant ids don't match
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Tidak dapat menambahkan ke keranjang!'),
              content: Text(
                  'Anda tidak dapat memesan dari tenant yang berbeda dalam satu pesanan. Silakan hapus semua item dari tenant sebelumnya terlebih dahulu.'),
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
        return; // Exit the function early if there's a mismatch
      }
    }

    // If no mismatch found, proceed with adding the item to the cart
    final existingCartItem = await DatabaseHelper.instance
        .queryCartItemByIds(widget.tenant.id, widget.menu.id);

    if (existingCartItem != null) {
      // If the cart item already exists, update its quantity
      existingCartItem.quantity++;
      await DatabaseHelper.instance.updateCartItem(existingCartItem);
    } else {
      // If the cart item doesn't exist, create a new one
      final cartItem = CartItemModel(
        id: null,
        idTenant: widget.tenant.id,
        idMenu: widget.menu.id,
        quantity: 1,
        harga: int.parse(widget.menu.hargaProduk),
      );
      await DatabaseHelper.instance.insertCartItem(cartItem);
    }

    await _getQuantityFromDatabase();
  }

  Future<void> removeFromCart() async {
    final existingCartItem = await DatabaseHelper.instance
        .queryCartItemByIds(widget.tenant.id, widget.menu.id);

    if (existingCartItem != null) {
      if (existingCartItem.quantity > 1) {
        // If the quantity is greater than 1, decrement it
        existingCartItem.quantity--;
        await DatabaseHelper.instance.updateCartItem(existingCartItem);
      } else {
        // If the quantity is 1, remove the cart item
        await DatabaseHelper.instance
            .deleteCartItem(widget.tenant.id, widget.menu.id);
      }
    }

    await _getQuantityFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.add_circle_outline,
              color: Color.fromRGBO(211, 36, 43, 1)),
          onPressed: addToCart,
        ),
        Text(
          quantity.toString(),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove_circle_outline,
              color: Color.fromRGBO(211, 36, 43, 1)),
          onPressed: removeFromCart,
        ),
      ],
    );
  }
}
