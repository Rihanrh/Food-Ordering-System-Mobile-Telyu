import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/BottomNavbarWidget.dart' as BottomNavigationBar;

class PaymentConfirmationLoadPage extends StatefulWidget {
  @override
  _PaymentConfirmationLoadPageState createState() => _PaymentConfirmationLoadPageState();
}

class _PaymentConfirmationLoadPageState extends State<PaymentConfirmationLoadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(211, 36, 43, 1),
        toolbarHeight: 40,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Pesananmu akan diproses setelah pembayaranmu terverifikasi', // Add your text here
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color : Color.fromRGBO(126, 0, 0,1),
                    fontSize: 18, // Adjust font size as needed
                    fontWeight: FontWeight.bold, // Adjust font weight as needed
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/tenantListImages/10.png', 
                width: 200, 
                height: 200, 
              ),
            ),
          ),
          SizedBox(height: 20), // Spacer
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BottomNavigationBar.BottomNavigationBar()),
                      );
                  
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
                  'Kembali Ke Halaman Utama',
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
