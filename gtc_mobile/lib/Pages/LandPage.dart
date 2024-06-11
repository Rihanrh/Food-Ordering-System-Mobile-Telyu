import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream

import '../Widgets/TenantListWidget.dart';
import '../Widgets/OngoingOrdersWidget.dart';
import '../Widgets/OrdersQueueWidget.dart';
import '../Widgets/SearchBarWidget.dart';
=======
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../Widgets/TenantListWidget.dart';
import '../Widgets/OngoingOrdersWidget.dart';
import 'dart:io';
import 'package:path/path.dart';
>>>>>>> Stashed changes

class LandPage extends StatefulWidget {
  @override
  _LandPageState createState() => _LandPageState();
}

class _LandPageState extends State<LandPage> {
  File? _imageFile;
  String imageFile = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final PickedFile = await _picker.pickImage(source: source);
    if (PickedFile != null) {
      setState(() {
        _imageFile = File(PickedFile.path);
      });
    }
    imageFile = await uploadImage(_imageFile!);
    setState(() {});
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);

    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    UploadTask task = ref.putFile(imageFile);
    TaskSnapshot snapshot = await task.whenComplete(() => {});

    return await snapshot.ref.getDownloadURL();
  }

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
              // Body
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< Updated upstream
                    TenantListWidget(),
=======
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : const NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/gtc-mobile-92e1e.appspot.com/o/Screenshot_20221028_233333.png?alt=media&token=6246b5bf-4241-4ebb-9e0a-347a6c48a885')
                                      as ImageProvider // Replace with your profile image asset
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
                              SizedBox(
                                  height:
                                      10), // Add some space between the user code and the button
                              ElevatedButton(
                                onPressed: () async {
                                  await _pickImage(ImageSource.camera);
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
                                  backgroundColor:
                                      Color.fromRGBO(211, 36, 43, 1),
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
>>>>>>> Stashed changes
                    OngoingOrdersWidget(),
                    OrdersQueueWidget(),
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
