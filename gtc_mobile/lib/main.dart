import 'dart:io';
import 'package:flutter/material.dart';
import 'Pages/LandPage.dart';
import 'Widgets/BottomNavBarWidget.dart' as BottomNavBarWidget;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gtc_mobile/Services/AkunPembeliService.dart';
import 'package:gtc_mobile/Models/PembeliModel.dart';
import 'package:device_info_plus/device_info_plus.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Get the device ID
  final deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor;
  }

  try {
    final existingPembeli = await AkunPembeliService.getPembeli(deviceId!);

    if (existingPembeli == null) {
      final newPembeli = await AkunPembeliService.createPembeli(deviceId!);
      debugPrint('New pembeli created: ${newPembeli.id}');
    } else {
      debugPrint('Existing pembeli found: ${existingPembeli.id}');
    }
  } catch (e) {
    debugPrint('Failed to get or create pembeli: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Telyu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(211, 36, 43, 1)
      ),
      
      home: BottomNavBarWidget.BottomNavigationBar(),
    );
  }
}
