import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Pages/HistoryOrderDetailPage.dart';

class HistoryOrdersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8, 
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
                                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HistoryOrderDetailPage()),
                      );
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
                                    'Kantin Lili',
                                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600,color : Color.fromRGBO(198, 0, 0,1)),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '3 Items',
                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600,color : Color.fromRGBO(126, 0, 0,1)),
                                  ),
                                  Text(
                                    'Nasi Goreng 1x,\nMi Goreng 2x',
                                    style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500,color : Color.fromRGBO(113, 0, 0,0.5)),
                                  ),
                                  Text(
                                    'Order Completed',
                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600,color : Color.fromRGBO(126, 0, 0,1)),
                                  ),
                                  Text(
                                    '29 May 03:00 PM',
                                    style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500,color : Color.fromRGBO(113, 0, 0,0.5)),
                                  ),
                                  Text(
                                    'Rp45.000',
                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600,color : Color.fromRGBO(126, 0, 0,1)),
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
                                    'assets/tenantListImages/${index + 1}.jpg', 
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
                            backgroundColor: MaterialStateProperty.all(Color.fromRGBO(211, 36, 43, 1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0), 
                              ),
                            ),
                          ),
                          onPressed: () {
                            debugPrint('Button pressed.');
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
      },
    );
  }
}
