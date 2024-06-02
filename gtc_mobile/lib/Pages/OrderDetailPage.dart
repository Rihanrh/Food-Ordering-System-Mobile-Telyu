import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtc_mobile/Models/PesananTenantModel.dart';
import 'package:gtc_mobile/Models/TenantMenuModel.dart';
import 'package:gtc_mobile/Services/PesananTenantService.dart';
import 'package:gtc_mobile/Services/TenantService.dart';
import '../Widgets/BottomNavBarWidget.dart' as BottomNavBar;

class OrderDetailPage extends StatefulWidget {
  final int idPesanan;

  OrderDetailPage({required this.idPesanan});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<List<PesananTenantModel>> _pesananFuture;

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
          'Rincian Pesanan',
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
                            '${firstPesanan.nomorMeja}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'ID Pesanan: ${firstPesanan.idPesanan}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(202, 37, 37, 1),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      firstPesanan.statusPesanan,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(202, 37, 37, 1),
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
                      'Rincian Pesanan',
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
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  ListTile(
                    title: Text(
                      'Metode Pembayaran: ${firstPesanan.metodePembayaran}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(126, 0, 0, 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            firstPesanan.statusPesanan == 'Pesanan Selesai'
                                ? () {}
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
