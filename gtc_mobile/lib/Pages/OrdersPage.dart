import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/SedangBerlangsungPesananWidget.dart';
import '../Widgets/HistoryOrdersWidget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90), 
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(211, 36, 43, 1),
            centerTitle: true,
            title: Text(
              'Status Pesanan',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            bottom: TabBar(
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              tabs: [
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      'Riwayat',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      'Sedang Berlangsung',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
              dividerColor: Color.fromRGBO(139, 29, 33, 1),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.white,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            HistoryOrdersWidget(),
            SedangBerlangsungPesananWidget(),
          ],
        ),
      ),
    );
  }
}
