import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/BottomNavBarWidget.dart' as BottomNavBar;

class OngoingOrderDetailPage extends StatefulWidget {
  @override
  _OngoingOrderDetailPageState createState() => _OngoingOrderDetailPageState();
}

class _OngoingOrderDetailPageState extends State<OngoingOrderDetailPage> {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            ListTile(
              title: Text(
                'Kantin Rasya',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(126, 0, 0, 1),
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
                'Status Pesanan',
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
                      '7',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'No Antrian : R123',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(202, 37, 37, 1),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Menunggu Verifikasi Pembayaran',
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
            ListTile(
              title: Text(
                'Nasi Goreng',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              ),
              trailing: Text(
                '2x',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Catatan : Jangan Pakai Sayur',
                style: GoogleFonts.poppins(
                  fontSize: 14,
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
                'Rincian Pembayaran',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(126, 0, 0, 1),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Nasi Goreng',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              ),
              trailing: Text(
                '54000',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Total Pembayaran',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: Text(
                '54000',
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
                'Metode Pembayaran : QRIS',
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
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(219, 219, 219, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Pesanan Diterima',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
