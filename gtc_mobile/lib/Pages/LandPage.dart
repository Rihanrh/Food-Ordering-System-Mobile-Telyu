import 'package:flutter/material.dart';

import '../Widgets/TenantListWidget.dart';
import '../Widgets/OngoingOrdersWidget.dart';
import '../Widgets/OrdersQueueWidget.dart';

class LandPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromRGBO(211, 36, 43, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 20,left: 15,top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),

              // Search Bar Widget
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [Icon(Icons.search),
                  Container(
                    margin: EdgeInsets.only(left:10),
                    width: 250,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Cari Kebutuhanmu",
                        border: InputBorder.none,
                      ),
                    ),
                  )

                  ],
                ),
              ),

              // Tenant List Widget
              Container(
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TenantListWidget(),
                    OngoingOrdersWidget(),
                    OrdersQueueWidget(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}