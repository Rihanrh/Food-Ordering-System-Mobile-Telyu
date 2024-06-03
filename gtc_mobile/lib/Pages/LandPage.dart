import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/TenantListWidget.dart';
import '../Widgets/OngoingOrdersWidget.dart';

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
              Container(
                padding: EdgeInsets.only(right: 20, left: 15, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/profile.jpg'), // Replace with your profile image asset
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, User!', 
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(211, 36, 43, 1),
                                ),
                              ),
                              SizedBox(height: 10), // Add some space between the user code and the button
                              ElevatedButton(
                                onPressed: () {
                                  // Implement your edit profile functionality here
                                },
                                child: Text(
                                  'Edit Profile',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(211, 36, 43, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    TenantListWidget(),
                     SizedBox(height: 20),
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
