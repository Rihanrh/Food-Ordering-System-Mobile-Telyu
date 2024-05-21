import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Models/PesananTenantModel.dart';
import 'package:gtc_mobile/Services/AkunPembeliService.dart';
import 'package:gtc_mobile/Services/PesananTenantService.dart';
import 'package:gtc_mobile/Services/TenantService.dart';
import '../Pages/OngoingOrderDetailPage.dart' as OngoingOrderDetailPage;
import 'package:collection/collection.dart'; // for groupBy

class OngoingOrdersWidget extends StatefulWidget {
  @override
  _OngoingOrdersWidgetState createState() => _OngoingOrdersWidgetState();
}

class _OngoingOrdersWidgetState extends State<OngoingOrdersWidget> {
  late Future<Map<int, List<PesananTenantModel>>> _pesananFuture;
  late int _idPembeli;

  @override
  void initState() {
    super.initState();
    _pesananFuture = _getPesananFuture();
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
    final pesananList = await PesananTenantsService.getPesananByIdPembeli(pembeli.id);
    final nonNullPesananList = pesananList.where((p) => p.idPesanan != null).toList();
    return groupBy(nonNullPesananList, (PesananTenantModel p) => p.idPesanan!);
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

  Future<String> getTenantMenuImageUrl(PesananTenantModel pesanan) async {
    final tenantMenuModel = await TenantService.getTenantMenuById(
      pesanan.idTenant,
      int.parse(pesanan.idMenu.toString().split(',')[0]),
    );
    return dotenv.env['API_URL']! + "/file/" + tenantMenuModel.fotoProduk;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12, top: 10),
                child: Text(
                  "Pesanan Sedang Berlangsung",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(211, 36, 43, 1),
                  ),
                ),
              )
            ],
          ),
        ),
        FutureBuilder<Map<int, List<PesananTenantModel>>>(
          future: _pesananFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final pesananGrouped = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: pesananGrouped.entries.map((entry) {
                    final idPesanan = entry.key;
                    final pesananList = entry.value;
                    final totalQuantity = pesananList.fold(0, (sum, item) => sum + item.quantity);
                    final firstPesanan = pesananList.first;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OngoingOrderDetailPage.OngoingOrderDetailPage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(25),
                        padding: EdgeInsets.all(5),
                        height: 200,
                        width: 390,
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
                        child: FutureBuilder<String>(
                          future: getTenantMenuImageUrl(firstPesanan),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final imageUrl = snapshot.data!;
                              return FutureBuilder<String>(
                                future: TenantService.getTenantNameById(firstPesanan.idTenant),
                                builder: (context, snapshotTenantName) {
                                  if (snapshotTenantName.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshotTenantName.hasError) {
                                    return Text('Error: ${snapshotTenantName.error}');
                                  } else {
                                    final tenantName = snapshotTenantName.data!;
                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'ID Pesanan : $idPesanan',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color.fromRGBO(126, 0, 0, 1),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      firstPesanan.statusPesanan,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w700,
                                                        color: Color.fromRGBO(198, 0, 0, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      tenantName,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color.fromRGBO(198, 0, 0, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$totalQuantity Menu',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color.fromRGBO(126, 0, 0, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Queue: ${firstPesanan.queue}',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color.fromRGBO(126, 0, 0, 1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Image.network(
                                                      imageUrl,
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
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
                                },
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
