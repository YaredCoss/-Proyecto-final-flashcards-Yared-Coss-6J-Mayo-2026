import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes/app_router.dart';
import 'firebase_options.dart';
import 'screens/welcome_screen.dart'; // pantalla 0
import 'screens/login_screen.dart'; // pantalla 1
import 'screens/register_screen.dart'; // pantalla 2
import 'screens/home_screen.dart'; // pantalla 3
import 'screens/progress_screen.dart'; // pantalla 4
import 'screens/search_screen.dart'; // pantalla 5
import 'screens/create_deck_screen.dart'; // pantalla 6
import 'screens/about_screen.dart'; // pantalla 7
import 'screens/deck_screen.dart'; // pantalla 8
import 'screens/create_card_screen.dart'; // pantalla 9
import 'screens/study_screen.dart'; // pantalla 10
import 'screens/session_result_screen.dart'; // pantalla 11
import 'screens/perfil_screen.dart'; // pantalla 12
import 'screens/edit_field_screen.dart'; // pantalla 13
import 'screens/logout_confirm_screen.dart'; // pantalla 14
import 'screens/logout_success_screen.dart'; // pantalla 15
import 'screens/admin_panel_screen.dart'; // pantalla 16
import 'screens/screen17.dart';
import 'screens/screen18.dart';
import 'screens/edit_card_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: '/',
    );
  }
}