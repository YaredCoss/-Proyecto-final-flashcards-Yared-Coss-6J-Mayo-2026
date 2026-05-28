import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
    Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),

        body: SafeArea(
        child: Center(
            child: ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: 420,
            ),

            child: Column(
                children: [

                // HEADER
                Container(
                    width: double.infinity,
                    color: const Color(0xFF424242),

                    padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 22,
                    ),

                    child: const Row(
                    children: [

                        Icon(
                        Icons.rocket_launch,
                        color: Colors.white,
                        size: 24,
                        ),

                        SizedBox(width: 10),

                        Text(
                        'Flashcard Estudio',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                        ),
                        ),
                    ],
                    ),
                ),

                // CONTENIDO
                Expanded(
                    child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(24),

                        child: Column(
                        children: [

                            // TARJETA IMAGEN
                            Container(
                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),

                                boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.08),
                                    offset: const Offset(0, 4),
                                ),
                                ],
                            ),

                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),

                                child: Image.network(
                                'https://raw.githubusercontent.com/YaredCoss/Imagenes-para-flutter-6J-11-02-2026/refs/heads/main/bienvenida.png',

                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                ),
                            ),
                            ),

                            const SizedBox(height: 36),

                            // DESCRIPCIÓN
                            const Text(
                            'Preparate para tus examenes, con una manera divertida y eficiente',

                            textAlign: TextAlign.center,

                            style: TextStyle(
                                fontSize: 20,
                                height: 1.5,
                                color: Color(0xFF333333),
                            ),
                            ),

                            const SizedBox(height: 32),

                            const Text(
                            'Iniciar como:',
                            style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF333333),
                            ),
                            ),

                            const SizedBox(height: 24),

                            // BOTÓN ADMIN
                            SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                                onPressed: () {
                                     Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                        builder: (_) => LoginScreen(isAdmin: true),
                                        ),
                                    );
                                },

                                style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF8C42),
                                foregroundColor: Colors.black,

                                padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                ),

                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                ),
                                ),

                                child: const Text(
                                'Administrador',
                                style: TextStyle(fontSize: 18),
                                ),
                            ),
                            ),

                            const SizedBox(height: 16),

                            // BOTÓN USUARIO
                            SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                                onPressed: () {
                                     Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                        builder: (_) => LoginScreen(),
                                        ),
                                    );
                                },

                                style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF8C42),
                                foregroundColor: Colors.black,

                                padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                ),

                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                ),
                                ),

                                child: const Text(
                                'Usuario',
                                style: TextStyle(fontSize: 18),
                                ),
                            ),
                            ),
                        ],
                        ),
                    ),
                    ),
                ),
                ],
            ),
            ),
        ),
        ),
    );
    }
}