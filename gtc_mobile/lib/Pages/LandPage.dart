import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Widgets/TenantListWidget.dart';
import '../Widgets/OngoingOrdersWidget.dart';
import '../Widgets/OrdersQueueWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

class LandPage extends StatefulWidget {
  @override
  _LandPageState createState() => _LandPageState();
}

class _LandPageState extends State<LandPage> {
  File? _imageFile;
  String imageFile = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      imageFile = await uploadImage(_imageFile!);
    }
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
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : const NetworkImage(
                                        'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=')
                                    as ImageProvider, // Replace with your profile image asset
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
                                },
                                child: Text(
                                  'Change Avatar',
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
                              SizedBox(
                                  height:
                                      10), // Add some space between the user code and the button
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
                      child: OrdersQueueWidget(),
                    ),
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
