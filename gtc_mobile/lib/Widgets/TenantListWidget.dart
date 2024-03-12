
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';


class TenantListWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10,right : 10,bottom: 0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tenant",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color : Color.fromRGBO(211, 36, 43, 1),
                ) ,
              )
            ],
          ),
        ),
        SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      for (int i = 1; i < 10; i++)
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          height: 100,
          width: 100,
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
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                  child: Image.asset(
                    'assets/$i.jpg',
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5), // Adjust the top padding as needed
                child: Text(
                  "Rasya",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(202, 37, 37, 1),
                  ),
                ),
              ),
            ],
          ),
        )
    ],
  ),
)

      ],
    );
  }
}