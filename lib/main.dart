import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_adaptor_gym/pages/bottom_navigation_bar_screen.dart';
import 'package:x_adaptor_gym/pages/splash_screen.dart';

String userId = '';
String firebaseToken = '';
AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDqUqqw7Vyn7QgABBcKhhfLwQCNnX-IOd0',
      appId: '1:560125531834:android:9654f3f00ed8d7954ed483',
      projectId: 'xgym-51d57',
      messagingSenderId: '560125531834',
    ),
  );
  await setupFlutterNotifications();
  showFlutterNotification(message);
  FirebaseFirestore.instance
      .collection('notifications')
      .doc(userId)
      .collection('notification_data')
      .doc(message.messageId)
      .set({
    'sender_id': message.senderId,
    'notification_title': message.notification?.title,
    'notification_body': message.notification?.body,
    'message_from': message.from,
    'sentTime': message.sentTime.toString(),
  });
  debugPrint(
      'Handling a background message with Message Sender Id-- ${message.senderId}');
  debugPrint(
      'Handling a background message with Message Send Time-- ${message.sentTime}');
  debugPrint(
      'Handling a background message with Notification Title-- ${message.notification?.title}');
  debugPrint(
      'Handling a background message with Notification Body-- ${message.notification?.body}');
  debugPrint(
      'Handling a background message with Message From-- ${message.from}');
}

Future<void> setupFlutterNotifications() async {
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel?.id ?? 'ID',
          channel?.name ?? 'NAME',
          channelDescription: channel?.description ?? 'DESCRIPTION',
          icon: '@mipmap/logo',
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDqUqqw7Vyn7QgABBcKhhfLwQCNnX-IOd0',
      appId: '1:560125531834:android:9654f3f00ed8d7954ed483',
      projectId: 'xgym-51d57',
      messagingSenderId: '560125531834',
    ),
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    setupFlutterNotifications();
    showFlutterNotification(message);

    FirebaseFirestore.instance
        .collection('notifications')
        .doc(userId)
        .collection('notification_data')
        .doc(message.messageId)
        .set({
      'sender_id': message.senderId,
      'notification_title': message.notification?.title,
      'notification_body': message.notification?.body,
      'message_from': message.from,
      'sentTime': message.sentTime.toString(),
    });
    debugPrint(
        'Handling a background message with Message ID-- ${message.messageId}');
    debugPrint(
        'Handling a background message with Message Send Time-- ${message.sentTime}');
    debugPrint(
        'Handling a background message with Notification Title-- ${message.notification?.title}');
    debugPrint(
        'Handling a background message with Notification Body-- ${message.notification?.body}');
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? not;

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID') ?? "";
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    firebaseToken = token!;
    debugPrint("deviceToken-- $firebaseToken");
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot != null) {
      not = snapshot.get('notification');
    }
    debugPrint('Notification is -- $not');
    setState(() {});
  }

  @override
  void initState() {
    getData();
    if (not == false) {
      FirebaseMessaging.instance.requestPermission(
        alert: false,
        badge: false,
        sound: false,
      );
      FirebaseMessaging.instance.setAutoInitEnabled(false);
    } else {
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.instance.setAutoInitEnabled(true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'X Adaptor Gym',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userId.isEmpty
          ? const SplashScreen()
          : const BottomNavigationBarScreen(),
    );
  }
}
