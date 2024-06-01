import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Pages/OrderDetailPage.dart' as OngoingOrderDetailPage;

class SedangBerlangsungPesananWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Center(
          child: SizedBox(
            width: 370,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card.filled(
                color: Colors.white,
                elevation: 5,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             OngoingOrderDetailPage.OngoingOrderDetailPage()),
                    //   );
                  },
                  child: Stack(
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
                                    'No. Antrian : R123',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(126, 0, 0, 1)),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Menunggu Konfirmasi Pembayaran',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(198, 0, 0, 1)),
                                  ),
                                  Text(
                                    'Kantin Rasya',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(198, 0, 0, 1)),
                                  ),
                                  Text(
                                    '2 Menu',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(126, 0, 0, 1)),
                                  ),
                                  Text(
                                    'Nasi Goreng 2x',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(113, 0, 0, 0.5)),
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
                                  child: Image.asset(
                                    'assets/tenantListImages/1.jpg',
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
                      Positioned(
                        bottom: 8.0,
                        right: 8.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(219, 219, 219, 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            debugPrint('Button pressed.');
                          },
                          child: Text(
                            'Pesanan Diterima',
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
      },
    );
  }
}
