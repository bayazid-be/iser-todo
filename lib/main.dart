import 'package:flutter/material.dart';
import 'package:isar_todo/pages/home_screen.dart';
import 'package:isar_todo/services/db_service.dart';
import 'package:isar_todo/services/notification/noti_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService.setUp();
  // init notification
  await NotiService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   final InitializationSettings initializationSettings =
//   InitializationSettings(android: initializationSettingsAndroid);
//
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   void _showNotification() async {
//     print('--------------------------------------');
//     print('----------------Calling----------------------');
//     print('--------------------------------------');
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'default_channel_id', // ✅ must not be null
//       'Default Channel', // ✅ must not be null
//       channelDescription: 'This is the default notification channel',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.show(
//       0, // ✅ must not be null
//       'Hello',
//       'This is a test notification',
//       platformChannelSpecifics,
//     );
//     print('--------------------------------------');
//     print('----------------done----------------------');
//     print('--------------------------------------');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Notification Test')),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: _showNotification,
//             child: const Text('Show Notification'),
//           ),
//         ),
//       ),
//     );
//   }
// }
