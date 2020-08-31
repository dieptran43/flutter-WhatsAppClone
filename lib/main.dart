import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:WhatsAppClone/core/theme.dart';

import 'package:WhatsAppClone/pages/views/loading_page.dart';
import 'package:WhatsAppClone/pages/main/main_page.dart';
import 'package:WhatsAppClone/pages/screens/login_page.dart';
import 'package:WhatsAppClone/pages/screens/select_contact_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      routes: {
        '/': (BuildContext context) => LoadingPage(),
        '/login_page': (BuildContext context) => LoginPage(),
        '/main_page': (BuildContext context) => MainPage()
      },
      onGenerateRoute: (RouteSettings settings) {
        Map<String, dynamic> arguments = settings.arguments;
        if (settings.name == '/contact_screen') {
          return MaterialPageRoute(builder: (context) {
            return SelectContactScreen(arguments['mode']);
          });
        }
        return MaterialPageRoute(builder: (context) {
          return MainPage();
        });
      },
    );
  }
}
