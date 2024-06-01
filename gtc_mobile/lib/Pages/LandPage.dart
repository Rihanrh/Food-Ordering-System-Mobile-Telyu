import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/TenantListWidget.dart';
import '../Widgets/OngoingOrdersWidget.dart';
import '../Widgets/SearchBarWidget.dart';

class LandPage extends StatefulWidget {
  @override
  _LandPageState createState() => _LandPageState();
}

class _LandPageState extends State<LandPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(211, 36, 43, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchBarWidget(),
              Container(
                padding: EdgeInsets.only(right: 20, left: 15, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TenantListWidget(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 5, top: 10),
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
                    OngoingOrdersWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
