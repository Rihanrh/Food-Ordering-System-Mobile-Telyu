import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SelectTable.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class CheckoutModal {
  static final _controller = ValueNotifier<bool>(false);

  static void show(BuildContext context) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return CheckoutModalWidget();
      },
    );
  }
}

class CheckoutModalWidget extends StatefulWidget {
  @override
  _CheckoutModalWidgetState createState() => _CheckoutModalWidgetState();
}

class _CheckoutModalWidgetState extends State<CheckoutModalWidget> {
  String _paymentMethod = 'Tunai'; // Default payment method
  String _catatan = ''; // Default catatan
  String _tempCatatan = ''; // Temporary catatan
  int? _selectedMejaNumber = 1;
  int? _temptSelectedMejaNumber;

  void _handlePaymentMethodChange(String value) {
    setState(() {
      _paymentMethod = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the value as needed
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
                                  items: List.generate(25, (index) => index + 1)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nasi Goreng',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(51, 51, 51, 1),
                          ),
                        ),
                        Text(
                          'Rp. 25.000',
                          style: GoogleFonts.poppins(
                            color: Color.fromRGBO(183, 73, 73, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
                        image: AssetImage('assets/tenantListImages/1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext Context) {
                                return AlertDialog(
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.cancel_outlined),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      Center(
                                        child: Text(
                                          'Catatan',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Opsional',
                                          style: GoogleFonts.poppins(
                                              fontSize: 10)),
                                      SizedBox(height: 13),
                                      TextFormField(
                                        onChanged: (value) {
                                          _tempCatatan =
                                              value; // Update temporary variable
                                        },
                                        initialValue: _tempCatatan,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.event_note),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          hintText:
                                              'Contoh: Jangan pakai sayur',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _catatan = _tempCatatan; // Assign tempCatatan to _catatan
                                        });
                                        print('Inputted Catatan: $_catatan');
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'Catatan',
                          style: GoogleFonts.poppins(
                            color: Color.fromRGBO(177, 27, 27, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: Color.fromRGBO(177, 27, 27, 1)),
                          )),
                        ),
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: CheckoutModal._controller,
                    enabled: true,
                    height: 35,
                    width: 150,
                    borderRadius: const BorderRadius.all(Radius.circular(120)),
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
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Color.fromRGBO(211, 36, 43, 1),
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    '1',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline,
                        color: Color.fromRGBO(211, 36, 43, 1)),
                    onPressed: () {},
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
                      'Rincian Pembayaran',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(126, 0, 0, 1),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Nasi Goreng',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(51, 51, 51, 1),
                      ),
                    ),
                    trailing: Text(
                      '28000',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(51, 51, 51, 1),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Nasi Goreng',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(51, 51, 51, 1),
                      ),
                    ),
                    trailing: Text(
                      '28000',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(51, 51, 51, 1),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Total Pembayaran',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(211, 36, 43, 1)),
                    ),
                    trailing: Text(
                      '54000',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(51, 51, 51, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

Future<void> _showSelectTableDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => SelectTableWidget(onTableSelected: (selectedTable) {
      // Do something with the selected table, e.g., update UI, call APIs, etc.
      print('Selected Table: $selectedTable');
      Navigator.pop(context); // Close the dialog
    }),
  );
}
