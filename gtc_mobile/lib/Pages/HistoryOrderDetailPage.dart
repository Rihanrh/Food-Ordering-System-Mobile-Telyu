import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/CheckoutWidget.dart';

class HistoryOrderDetailPage extends StatefulWidget {
  @override
  _HistoryOrderDetailPageState createState() => _HistoryOrderDetailPageState();
}

class _HistoryOrderDetailPageState extends State<HistoryOrderDetailPage> {
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
      body: Column(
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
              'x1',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),

          ListTile(
            title: Text(
              'Mie Goreng',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
            trailing: Text(
              'x2',
              style: GoogleFonts.poppins(
                fontSize: 16,
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
              'Rp 15.000',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),

          ListTile(
            title: Text(
              'Mie Goreng Goreng',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            ),
            trailing: Text(
              'Rp 30.000',
              style: GoogleFonts.poppins(
                fontSize: 16,
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
              width: double
                  .infinity,
              child: ElevatedButton(
                onPressed: () {
CheckoutModal.show(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromRGBO(211, 36, 43, 1),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                child: Text(
                  'Pesan Kembali',
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
}
