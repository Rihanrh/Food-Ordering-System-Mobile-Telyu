import 'package:flutter/material.dart';
import '../Widgets/MenusWidget.dart';
import '../Widgets/SearchBarWidget.dart';

class MenusPage extends StatefulWidget {
  @override
  _MenusPageState createState() =>_MenusPageState();
}

class _MenusPageState extends State<MenusPage> {
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
                  children: [
                    
                  ],
                ),
              ),
              // Body
              Container(
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    MenusWidget(),
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