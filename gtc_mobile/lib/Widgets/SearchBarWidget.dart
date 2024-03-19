import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Cari Kebutuhanmu",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
  padding: const EdgeInsets.only(right: 8.0),
  child: Stack(
    children: [
      IconButton(
        icon: Icon(
          Icons.shopping_cart_checkout_outlined,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {},
      ),
      Positioned(
        right: 2,
        top: 2,
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Text(
            '5', 
            style: TextStyle(
              color: Color.fromRGBO(202, 37, 37, 1),
              fontSize: 12,
            ),
          ),
        ),
      ),
    ],
  ),
),

      ],
    );
  }
}