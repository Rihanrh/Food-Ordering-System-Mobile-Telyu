import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Services/AkunPembeliService.dart';
import '../Pages/PaymentConfirmationLoadPage.dart';
import 'package:gtc_mobile/Models/CartItemModel.dart';
import 'package:gtc_mobile/Services/DatabaseHelper.dart';
import 'package:gtc_mobile/Models/TenantModel.dart';
import 'package:gtc_mobile/Models/TenantMenuModel.dart';
import 'package:gtc_mobile/Services/TenantService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gtc_mobile/Models/PesananTenantModel.dart';
import 'package:gtc_mobile/Services/PesananTenantService.dart';

class CheckoutModal {
  static final _controller = ValueNotifier<bool>(false);

  static void show(BuildContext context) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: CheckoutPage(),
        );
      },
    );
  }
}

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int? _idPembeli;
  int _totalPrice = 0;

  late Future<List<CartItemModel>> _futureCartItems;

  String _paymentMethod = 'Tunai';
  int? _selectedMejaNumber = 1;
  int? _temptSelectedMejaNumber;
  String _consumptionOption = "Dibungkus";

  void _handlePaymentMethodChange(String value) {
    setState(() {
      _paymentMethod = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureCartItems = _getCartItems();
    _getIdPembeli();
    _updateTotalPrice();

    _calculateTotalPrice().then((totalPrice) {
      setState(() {
        _totalPrice = totalPrice;
      });
    });

    CheckoutModal._controller.addListener(() {
      if (mounted) {
        setState(() {
          _consumptionOption =
              CheckoutModal._controller.value ? "Makan di Tempat" : "Dibungkus";
        });
      }
    });
  }

  Future<void> _getIdPembeli() async {
    final deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }

    try {
      final existingPembeli = await AkunPembeliService.getPembeli(deviceId!);
      if (existingPembeli != null) {
        setState(() {
          _idPembeli = existingPembeli.id;
        });
      } else {
        final newPembeli = await AkunPembeliService.createPembeli(deviceId);
        setState(() {
          _idPembeli = newPembeli.id;
        });
      }
    } catch (e) {
      debugPrint('Failed to get or create pembeli: $e');
    }
  }

  Future<List<CartItemModel>> _getCartItems() async {
    final List<Map<String, dynamic>> cartItemsMaps =
        await DatabaseHelper.instance.queryCartItems();
    final List<CartItemModel> cartItems =
        cartItemsMaps.map((map) => CartItemModel.fromJson(map)).toList();
    return cartItems;
  }

  void _refreshCartItems() {
    setState(() {
      _futureCartItems = _getCartItems();
    });
  }

  Future<TenantMenuModel> _getTenantMenu(int idTenant, int idMenu) async {
    return await TenantService.getTenantMenuById(idTenant, idMenu);
  }

  Future<int> _calculateTotalPrice() async {
    final cartItems = await _futureCartItems;
    int totalPrice = 0;

    for (final cartItem in cartItems) {
      totalPrice += cartItem.harga * cartItem.quantity;
    }

    return totalPrice;
  }

  void _updateTotalPrice() {
    _calculateTotalPrice().then((totalPrice) {
      setState(() {
        _totalPrice = totalPrice;
      });
    });
  }

  Widget _buildCartItemList() {
    return FutureBuilder<List<CartItemModel>>(
      future: _futureCartItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true, // Important to make the ListView wrap its content
            physics:
                NeverScrollableScrollPhysics(), // Disable scrolling inside ListView
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final cartItem = snapshot.data![index];
              return FutureBuilder<TenantMenuModel>(
                future: _getTenantMenu(cartItem.idTenant, cartItem.idMenu),
                builder: (context, tenantMenuSnapshot) {
                  if (tenantMenuSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (tenantMenuSnapshot.hasError) {
                    return Text('Error: ${tenantMenuSnapshot.error}');
                  } else if (tenantMenuSnapshot.hasData) {
                    final tenantMenu = tenantMenuSnapshot.data!;
                    return FutureBuilder<TenantModel>(
                      future: TenantService.getTenant(cartItem.idTenant),
                      builder: (context, tenantSnapshot) {
                        if (tenantSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (tenantSnapshot.hasError) {
                          return Text('Error: ${tenantSnapshot.error}');
                        } else if (tenantSnapshot.hasData) {
                          final tenant = tenantSnapshot.data!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tenantMenu.namaProduk,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(51, 51, 51, 1),
                                        ),
                                      ),
                                      Text(
                                        'Rp. ${tenantMenu.hargaProduk}',
                                        style: GoogleFonts.poppins(
                                          color: Color.fromRGBO(183, 73, 73, 1),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Quantity: ${cartItem.quantity}',
                                        style: GoogleFonts.poppins(
                                          color: Color.fromRGBO(183, 73, 73, 1),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 60,
                                height: 60,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(dotenv.env['API_URL']! +
                                        "/file/" +
                                        tenantMenu.fotoProduk),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline,
                                        color: Color.fromRGBO(211, 36, 43, 1)),
                                    onPressed: () async {
                                      await CartHelper.addToCart(
                                          tenant,
                                          tenantMenu,
                                          _refreshCartItems,
                                          _updateTotalPrice);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline,
                                        color: Color.fromRGBO(211, 36, 43, 1)),
                                    onPressed: () async {
                                      await CartHelper.removeFromCart(
                                          tenant,
                                          tenantMenu,
                                          _refreshCartItems,
                                          _updateTotalPrice);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, right: 0, top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Checkout',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(126, 0, 0, 1),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Nomor Meja',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(126, 0, 0, 1),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 45,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(126, 0, 0, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$_selectedMejaNumber',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 335,
                      margin: EdgeInsets.all(10),
                      child: OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.cancel_outlined),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Center(
                                      child: Text(
                                        'Pilih Nomor Meja',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(126, 0, 0, 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pilihlah nomor meja sesuai yang terletak di meja.',
                                      style: GoogleFonts.poppins(fontSize: 10),
                                    ),
                                    SizedBox(height: 13),
                                    DropdownButtonFormField<int>(
                                      value: _temptSelectedMejaNumber ??
                                          _selectedMejaNumber,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          _temptSelectedMejaNumber = newValue;
                                        });
                                      },
                                      items:
                                          List.generate(25, (index) => index + 1)
                                              .map((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text('$value'),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        labelText: 'Nomor Meja',
                                        prefixIcon: Icon(Icons.table_restaurant),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (_temptSelectedMejaNumber != null) {
                                        setState(() {
                                          _selectedMejaNumber =
                                              _temptSelectedMejaNumber;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                            color: Color.fromRGBO(126, 0, 0, 1),
                            width: 2,
                          )),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Pilih Nomor Meja',
                            style: GoogleFonts.poppins(
                              color: Color.fromRGBO(126, 0, 0, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  SizedBox(height: 10),
                  _buildCartItemList(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AdvancedSwitch(
                        controller: CheckoutModal._controller,
                        enabled: true,
                        height: 35,
                        width: 150,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(120)),
                        inactiveColor: Colors.grey,
                        activeColor: Color.fromRGBO(202, 37, 37, 1),
                        inactiveChild: Text(
                          "Dibungkus",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        activeChild: Text(
                          "Makan di Tempat",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      'Metode Pembayaran',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(126, 0, 0, 1),
                      ),
                    ),
                  ),
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        Icon(Icons.payments_outlined),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tunai ( Bayar di Kasir )',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(51, 51, 51, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: 'Tunai',
                    groupValue: _paymentMethod,
                    onChanged: (String? value) {
                      _handlePaymentMethodChange(value ?? '');
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Color.fromRGBO(211, 36, 43, 1),
                  ),
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        Icon(Icons.qr_code_scanner_outlined),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'QRIS ( Bayar di Tenant )',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(51, 51, 51, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: 'QRIS',
                    groupValue: _paymentMethod,
                    onChanged: (String? value) {
                      _handlePaymentMethodChange(value ?? '');
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Color.fromRGBO(211, 36, 43, 1),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Total Pembayaran',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(211, 36, 43, 1)),
                        ),
                        trailing: Text(
                          'Rp $_totalPrice',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(51, 51, 51, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          int? maxIdPesanan;
                          try {
                            maxIdPesanan =
                                await PesananTenantsService.getMaxIdPesanan();
                          } catch (e) {
                            debugPrint('Failed to get max idPesanan: $e');
                            return;
                          }
        
                          final newIdPesanan =
                              (maxIdPesanan != null ? maxIdPesanan + 1 : 1);
                          final cartItems = await _futureCartItems;
        
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Konfirmasi Pesanan"),
                                content: Text(
                                    "Apakah Anda yakin ingin melakukan pemesanan? Pastikan pesanan Anda sudah benar."),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("Batal"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Ya"),
                                    onPressed: () async {
                                      // Proceed with the order confirmation
                                      for (final cartItem in cartItems) {
                                        final pesananTenant = PesananTenantModel(
                                          id: null,
                                          idTenant: cartItem.idTenant,
                                          idMenu: cartItem.idMenu,
                                          idPesanan: newIdPesanan,
                                          quantity: cartItem.quantity,
                                          totalHarga: cartItem.harga,
                                          metodePembayaran: _paymentMethod,
                                          statusPesanan:
                                              'Menunggu Konfirmasi Pembayaran',
                                          nomorMeja: _selectedMejaNumber!,
                                          opsiKonsumsi: _consumptionOption,
                                          queue: null,
                                          idPembeli: _idPembeli,
                                        );
        
                                        try {
                                          await PesananTenantsService
                                              .createPesanan(pesananTenant);
                                        } catch (e) {
                                          debugPrint(
                                              'Failed to create pesanan: $e');
                                        }
                                      }
        
                                      // Navigate to the PaymentConfirmationLoadPage
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentConfirmationLoadPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(211, 36, 43, 1),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Pesan',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CartHelper {
  static Future<void> addToCart(
      TenantModel tenant,
      TenantMenuModel menu,
      void Function() refreshCartItems,
      void Function() updateTotalPrice) async {
    final existingCartItem =
        await DatabaseHelper.instance.queryCartItemByIds(tenant.id, menu.id);

    if (existingCartItem != null) {
      // If the cart item already exists, update its quantity
      existingCartItem.quantity++;
      await DatabaseHelper.instance.updateCartItem(existingCartItem);
    } else {
      // If the cart item doesn't exist, create a new one
      final cartItem = CartItemModel(
        id: null,
        idTenant: tenant.id,
        idMenu: menu.id,
        quantity: 1,
        harga: int.parse(menu.hargaProduk),
      );
      await DatabaseHelper.instance.insertCartItem(cartItem);
    }

    refreshCartItems();
    updateTotalPrice();
  }

  static Future<void> removeFromCart(
      TenantModel tenant,
      TenantMenuModel menu,
      void Function() refreshCartItems,
      void Function() updateTotalPrice) async {
    final existingCartItem =
        await DatabaseHelper.instance.queryCartItemByIds(tenant.id, menu.id);

    if (existingCartItem != null) {
      if (existingCartItem.quantity > 1) {
        // If the quantity is greater than 1, decrement it
        existingCartItem.quantity--;
        await DatabaseHelper.instance.updateCartItem(existingCartItem);
      } else {
        // If the quantity is 1, remove the cart item
        await DatabaseHelper.instance.deleteCartItem(tenant.id, menu.id);
      }
    }

    refreshCartItems();
    updateTotalPrice();
  }
}
