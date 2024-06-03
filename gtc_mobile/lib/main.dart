import 'dart:io';
import 'package:flutter/material.dart';
import 'Widgets/BottomNavBarWidget.dart' as BottomNavBarWidget;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gtc_mobile/Services/AkunPembeliService.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:gtc_mobile/Services/DatabaseHelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
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

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    FlutterLocalNotificationsPlugin().initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              icon: "@mipmap/ic_launcher",
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle navigation when the app is opened from a notification
      _handleNotificationNavigation(message);
    });
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    // Navigate to the BottomNavigationBar widget
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBarWidget.BottomNavigationBar()),
    );
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