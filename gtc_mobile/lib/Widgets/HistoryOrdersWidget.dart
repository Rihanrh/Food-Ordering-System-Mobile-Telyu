import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Models/PesananTenantModel.dart';
import 'package:gtc_mobile/Models/TenantMenuModel.dart';
import 'package:gtc_mobile/Pages/ReorderPage.dart';
import 'package:gtc_mobile/Services/AkunPembeliService.dart';
import 'package:gtc_mobile/Services/PesananTenantService.dart';
import 'package:gtc_mobile/Services/TenantService.dart';
import 'package:gtc_mobile/Pages/OrderDetailPage.dart';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';

class HistoryOrdersWidget extends StatefulWidget {
  @override
  _HistoryOrdersWidgetState createState() => _HistoryOrdersWidgetState();
}

class _HistoryOrdersWidgetState extends State<HistoryOrdersWidget> {
  late Future<Map<int, List<PesananTenantModel>>> _pesananFuture;

  @override
  void initState() {
    super.initState();
    _pesananFuture = _getPesananFuture();
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

  Future<Map<int, List<PesananTenantModel>>> _getPesananFuture() async {
    final deviceId = await _getDeviceId();
    if (deviceId == null) {
      return {};
    }
    final pembeli = await AkunPembeliService.getPembeli(deviceId);
    if (pembeli == null) {
      return {};
    }
    try {
      final pesananList =
          await PesananTenantsService.getPesananByIdPembeli(pembeli.id);
      final nonNullPesananList =
          pesananList.where((p) => p.idPesanan != null).toList();
      final filteredPesananList = nonNullPesananList
          .where((p) => p.statusPesanan == 'Pesanan Selesai')
          .toList();
      return groupBy(
          filteredPesananList, (PesananTenantModel p) => p.idPesanan!);
    } catch (e) {
      if (e.toString().contains('404')) {
        // Handle 404 error, return an empty map
        return {};
      } else {
        // Rethrow other errors
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, List<PesananTenantModel>>>(
      future: _pesananFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada pesanan yang telah selesai!'));
        } else {
          final pesananGrouped = snapshot.data!;
          return ListView.builder(
            itemCount: pesananGrouped.length,
            itemBuilder: (context, index) {
              final entry = pesananGrouped.entries.elementAt(index);
              final pesananList = entry.value;
              final totalQuantity =
                  pesananList.fold(0, (sum, item) => sum + item.quantity);
              final totalHarga = pesananList.fold(
                0,
                (sum, item) => sum + item.quantity * item.totalHarga,
              );
              final firstPesanan = pesananList.first;

              return FutureBuilder<String>(
                future: TenantService.getTenantNameById(firstPesanan.idTenant),
                builder: (context, snapshotTenantName) {
                  if (snapshotTenantName.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshotTenantName.hasError) {
                    return Center(
                        child: Text('Error: ${snapshotTenantName.error}'));
                  } else {
                    final tenantName = snapshotTenantName.data!;
                    return Center(
                      child: SizedBox(
                        width: 370,
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card.filled(
                            color: Colors.white,
                            elevation: 5,
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDetailPage(idPesanan: entry.key),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Kantin $tenantName',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromRGBO(
                                                        198, 0, 0, 1)),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '$totalQuantity Menu',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromRGBO(
                                                        126, 0, 0, 1)),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (pesananList.isNotEmpty)
                                                    FutureBuilder<
                                                        TenantMenuModel>(
                                                      future: TenantService
                                                          .getTenantMenuById(
                                                              pesananList.first
                                                                  .idTenant,
                                                              pesananList.first
                                                                  .idMenu),
                                                      builder: (context,
                                                          snapshotMenu) {
                                                        if (snapshotMenu
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Text(
                                                              'Loading...');
                                                        } else if (snapshotMenu
                                                            .hasError) {
                                                          return Text(
                                                              'Error: ${snapshotMenu.error}');
                                                        } else {
                                                          final menu =
                                                              snapshotMenu
                                                                  .data!;
                                                          final firstPesanan =
                                                              pesananList.first;
                                                          final displayText =
                                                              '${menu.namaProduk} ${firstPesanan.quantity}x';
                                                          return Text(
                                                            pesananList.length >
                                                                    1
                                                                ? '$displayText, ...'
                                                                : displayText,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      113,
                                                                      0,
                                                                      0,
                                                                      0.5),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                ],
                                              ),
                                              Text(
                                                'Rp. $totalHarga',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromRGBO(
                                                        126, 0, 0, 1)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 40.0,
                                    right: 30.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromRGBO(211, 36, 43, 1)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ReorderPage(
                                                    idPesanan: entry.key),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Pesan Kembali',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
