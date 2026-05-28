import 'package:flutter/material.dart';

// SCREENS
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/search_screen.dart';
import '../screens/create_deck_screen.dart';
import '../screens/about_screen.dart';
import '../screens/deck_screen.dart';
import '../screens/create_card_screen.dart';
import '../screens/study_screen.dart';
import '../screens/session_result_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/edit_field_screen.dart';
import '../screens/logout_confirm_screen.dart';
import '../screens/logout_success_screen.dart';
import '../screens/admin_panel_screen.dart';
import '../screens/screen17.dart';
import '../screens/screen18.dart';
import '../screens/edit_card_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {

      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen(isAdmin: false));

      case '/login-admin':
        return MaterialPageRoute(builder: (_) => const LoginScreen(isAdmin: true));

      case '/registro':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/progreso':
        return MaterialPageRoute(builder: (_) => const ProgressScreen());

      case '/busqueda':
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case '/crear-mazo':
        return MaterialPageRoute(builder: (_) => const CreateDeckScreen());

      case '/nosotros':
        return MaterialPageRoute(builder: (_) => const AboutScreen());

      // 🧠 MAZO (equivalente a /mazo/:id)
      case '/mazo':
        final data = args as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DeckScreen(
            deckId: data['id'],
            deckTitle: data['title'],
          ),
        );

      case '/anadir-tarjeta':
        final data = args as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CreateCardScreen(
            deckId: data['deckId'],
            deckTitle: data['deckTitle'] ?? '',
          ),
        );

      case '/editar-tarjeta':
        final data = args as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => EditCardScreen(
            cardId: data['cardId'],
            front: data['front'],
            correctAnswer: data['correctAnswer'],
            options: List<String>.from(data['options']),
          ),
        );

      case '/estudiar':
        final data = args as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => StudyScreen(
            deckId: data['deckId'],
            deckTitle: data['deckTitle'],
          ),
        );

      case '/resumen':
        final data = args as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SessionResultScreen(
            correctAnswers: data['correctAnswers'],
            wrongAnswers: data['wrongAnswers'],
            deckId: data['deckId'],
            deckTitle: data['deckTitle'],
            wrongCards: data['wrongCards'],

          ),
        );

      case '/editar-perfil':
        return MaterialPageRoute(builder: (_) => const Screen12());

      case '/editar-nombre':
        return MaterialPageRoute(builder: (_) => const ScreenEditFieldScreen(field: '',));

      case '/confirmar-cierre':
        return MaterialPageRoute(builder: (_) => const LogoutConfirmScreen());

      case '/despedida':
        return MaterialPageRoute(builder: (_) => const LogoutSuccessScreen());

      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminPanelScreen());

      case '/admin/reportados':
        return MaterialPageRoute(builder: (_) => const Screen17());

      case '/admin/revisar':
        final data = args as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => Screen18(
            deckId: data['id'],
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}