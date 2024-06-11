import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Models/PesananTenantModel.dart';
import 'package:gtc_mobile/Models/TenantMenuModel.dart';
import 'package:gtc_mobile/Pages/PaymentConfirmationLoadPage.dart';
import 'package:gtc_mobile/Services/AkunPembeliService.dart';
import 'package:gtc_mobile/Services/PesananTenantService.dart';
import 'package:gtc_mobile/Services/TenantService.dart';

class ReorderPage extends StatefulWidget {
  final int idPesanan;
  static final _controller = ValueNotifier<bool>(false);

  ReorderPage({required this.idPesanan});

  @override
  _ReorderPageState createState() => _ReorderPageState();
}

class _ReorderPageState extends State<ReorderPage> {
  late Future<List<PesananTenantModel>> _pesananFuture;

  String _paymentMethod = 'Tunai';
  int? _selectedMejaNumber = 1;
  int? _temptSelectedMejaNumber;

  void _handlePaymentMethodChange(String value) {
    setState(() {
      _paymentMethod = value;
    });
  }

  Future<String?> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _pesananFuture =
        PesananTenantsService.getPesananByIdPesanan(widget.idPesanan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromRGBO(211, 36, 43, 1),
        toolbarHeight: 80,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Pesan Kembali',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<PesananTenantModel>>(
        future: _pesananFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final pesananList = snapshot.data!;
            final firstPesanan = pesananList.first;
            final totalHarga = pesananList.fold(
              0,
              (sum, item) => sum + item.quantity * item.totalHarga,
            );

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  FutureBuilder<String>(
                    future:
                        TenantService.getTenantNameById(firstPesanan.idTenant),
                    builder: (context, snapshotTenantName) {
                      if (snapshotTenantName.connectionState ==
                          ConnectionState.waiting) {
                        return ListTile(title: Text('Loading...'));
                      } else if (snapshotTenantName.hasError) {
                        return ListTile(
                            title: Text('Error: ${snapshotTenantName.error}'));
                      } else {
                        final tenantName = snapshotTenantName.data!;
                        return ListTile(
                          title: Text(
                            'Tenant $tenantName',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(126, 0, 0, 1),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    height: 1,
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
                                      items: List.generate(
                                              25, (index) => index + 1)
                                          .map((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text('$value'),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        labelText: 'Nomor Meja',
                                        prefixIcon:
                                            Icon(Icons.table_restaurant),
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
                  ListTile(
                    title: Text(
                      'Detail Pesanan',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(126, 0, 0, 1),
                      ),
                    ),
                  ),
                  Column(
                    children: pesananList.map((pesanan) {
                      return FutureBuilder<TenantMenuModel>(
                        future: TenantService.getTenantMenuById(
                            pesanan.idTenant, pesanan.idMenu),
                        builder: (context, snapshotMenu) {
                          if (snapshotMenu.connectionState ==
                              ConnectionState.waiting) {
                            return ListTile(
                              title: Text('Loading...'),
                            );
                          } else if (snapshotMenu.hasError) {
                            return ListTile(
                              title: Text('Error: ${snapshotMenu.error}'),
                            );
                          } else {
                            final menu = snapshotMenu.data!;
                            return ListTile(
                              title: Text(
                                menu.namaProduk,
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.black),
                              ),
                              trailing: Text(
                                '${pesanan.quantity}x',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  ListTile(
                    title: Text(
                      'Metode Pembayaran:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
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
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  ListTile(
                    title: Text(
                      'Opsi Makan:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(126, 0, 0, 1),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AdvancedSwitch(
                        controller: ReorderPage._controller,
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
                  ListTile(
                    title: Text(
                      'Total Pembayaran',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(
                      '$totalHarga',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: firstPesanan.statusPesanan ==
                                'Pesanan Selesai'
                            ? () async {
                                int? maxIdPesanan;
                                try {
                                  maxIdPesanan = await PesananTenantsService
                                      .getMaxIdPesanan();
                                } catch (e) {
                                  debugPrint('Failed to get max idPesanan: $e');
                                  return;
                                }

                                final newIdPesanan = (maxIdPesanan != null
                                    ? maxIdPesanan + 1
                                    : 1);

                                final deviceId = await _getDeviceId();
                                if (deviceId == null) {
                                  // Handle the case when device ID is null
                                  debugPrint('Failed to get device ID');
                                  return;
                                }

                                final pembeli =
                                    await AkunPembeliService.getPembeli(
                                        deviceId);
                                if (pembeli == null) {
                                  // Handle the case when pembeli is null
                                  debugPrint('Failed to get pembeli');
                                  return;
                                }

                                final idPembeli = pembeli.id;

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Konfirmasi Pesanan"),
                                      content: Text(
                                          "Apakah Anda yakin ingin melakukan pemesanan ulang? Pastikan pesanan Anda sudah benar."),
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
                                            // Proceed with the reorder confirmation
                                            for (final pesanan in pesananList) {
                                              final newPesananTenant =
                                                  PesananTenantModel(
                                                id: null,
                                                idTenant: pesanan.idTenant,
                                                idMenu: pesanan.idMenu,
                                                idPesanan: newIdPesanan,
                                                quantity: pesanan.quantity,
                                                totalHarga: pesanan.totalHarga,
                                                metodePembayaran:
                                                    _paymentMethod,
                                                statusPesanan:
                                                    'Menunggu Konfirmasi Pembayaran',
                                                nomorMeja: _selectedMejaNumber!,
                                                opsiKonsumsi: ReorderPage
                                                        ._controller.value
                                                    ? 'Makan di Tempat'
                                                    : 'Dibungkus',
                                                queue: null,
                                                idPembeli: idPembeli,
                                              );

                                              try {
                                                await PesananTenantsService
                                                    .createPesanan(
                                                        newPesananTenant);
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
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Color.fromRGBO(219, 219, 219, 1);
                              }
                              return Color.fromRGBO(211, 36, 43, 1);
                            },
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: Text(
                          firstPesanan.statusPesanan == 'Pesanan Selesai'
                              ? 'Pesan Kembali'
                              : 'Pesanan Diterima',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
