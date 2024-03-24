import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutModal {
  static final _controller = ValueNotifier<bool>(false);
  static String _paymentMethod = 'Tunai'; // Default payment method

  static void show(BuildContext context) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            Container(
          padding: EdgeInsets.only(left: 0, right: 0, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  'Checkout',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(126, 0, 0, 1),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Nomor Meja',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(126, 0, 0, 1),
                  ),
                ),
                onTap: () {},
              ),
              Center(
                child: Container(
                  width: 335,
                  margin: EdgeInsets.all(10),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                        color: Color.fromRGBO(126, 0, 0, 1),
                        width: 2,
                      )),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Pilih Nomor Meja',
                        style: GoogleFonts.poppins(
                          color: Color.fromRGBO(126, 0, 0, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 10),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nasi Goreng',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(51, 51, 51, 1),
                          ),
                        ),
                        Text(
                          'Rp. 25.000',
                          style: GoogleFonts.poppins(
                            color: Color.fromRGBO(183, 73, 73, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage('assets/tenantListImages/1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Catatan',
                          style: GoogleFonts.poppins(
                            color: Color.fromRGBO(177, 27, 27, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: Color.fromRGBO(177, 27, 27, 1)),
                          )),
                        ),
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: _controller,
                    enabled: true,
                    height: 35,
                    width: 150,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(120)),
                    inactiveColor: Colors.grey,
                    activeColor: Color.fromRGBO(202, 37, 37, 1),
                    inactiveChild: Text(
                      "Dibungkus",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    activeChild: Text(
                      "Makan di Tempat",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Color.fromRGBO(211, 36, 43, 1),
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    '1',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline,
                        color: Color.fromRGBO(211, 36, 43, 1)),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  'Metode Pembayaran',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(126, 0, 0, 1),
                  ),
                ),
              ),
              RadioListTile(
                title: Text('Tunai'),
                value: 'Tunai',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState((){
                    _paymentMethod = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('QRIS'),
                value: 'QRIS',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState((){
                    _paymentMethod = value!;
                  });
                },
              ),
            ],
          ),
        )
          ],
        );
      },
    );
  }
}