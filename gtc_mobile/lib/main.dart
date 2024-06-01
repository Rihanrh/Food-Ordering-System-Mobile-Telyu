import 'dart:io';
import 'package:flutter/material.dart';
import 'Widgets/BottomNavBarWidget.dart' as BottomNavBarWidget;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gtc_mobile/Services/AkunPembeliService.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:gtc_mobile/Services/DatabaseHelper.dart';

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
      final newPembeli = await AkunPembeliService.createPembeli(deviceId);
      debugPrint('New pembeli created: ${newPembeli.id}');
    } else {
      debugPrint('Existing pembeli found: ${existingPembeli.id}');
    }
  } catch (e) {
    debugPrint('Failed to get or create pembeli: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    DatabaseHelper.instance.dispose(); // Ensure database is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      DatabaseHelper.instance.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Telyu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(211, 36, 43, 1),
      ),
      home: BottomNavBarWidget.BottomNavigationBar(),
    );
  }
}
