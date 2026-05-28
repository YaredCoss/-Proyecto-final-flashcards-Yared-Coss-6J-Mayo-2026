import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isHomeHovered = false;
  bool isSearchHovered = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: Column(
          children: [
            // APPBAR
            Container(
              width: double.infinity,
              color: const Color(0xFF424242),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 22,
              ),
              child: const Center(
                child: Text(
                  'Tu progreso',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),

            // CONTENIDO
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final reviewedToday = data['reviewedToday'] ?? 0;
                  final dailyGoal = data['dailyGoal'] ?? 20;
                  final totalMinutes = data['totalStudyMinutes'] ?? 0;
                  final totalCards = data['totalCardsCreated'] ?? 0;

                  // PORCENTAJES
                  double completed = reviewedToday / dailyGoal;
                  if (completed > 1) {
                    completed = 1;
                  }
                  final pending = 1 - completed;

                  // HORAS
                  final hours = (totalMinutes / 60).toStringAsFixed(1);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // CÍRCULOS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            progressCircle(
                              percent: completed,
                              color: Colors.green,
                              text: '${(completed * 100).toInt()}%',
                              label: 'Completado',
                            ),
                            progressCircle(
                              percent: pending,
                              color: Colors.red,
                              text: '${(pending * 100).toInt()}%',
                              label: 'Pendiente',
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),
                        // ACTIVIDAD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                color: Colors.black.withOpacity(0.05),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Actividad',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    color: Color(0xFFFF8C42),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Tiempo total: ',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '$hours h',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFFFF8C42),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.style,
                                    color: Color(0xFFFF8C42),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Tarjetas creadas: ',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '$totalCards',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFFFF8C42),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),
                        // INFO
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                color: Colors.black.withOpacity(0.05),
                              ),
                            ],
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¿Cómo funciona?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                '✅ Completado representa el porcentaje de tu objetivo diario alcanzado.',
                              ),
                              SizedBox(height: 12),
                              Text(
                                '⏳ Pendiente muestra lo que falta para terminar tu meta del día.',
                              ),
                              SizedBox(height: 12),
                              Text(
                                '📚 Las tarjetas creadas aumentan cada vez que haces una nueva flashcard.',
                              ),
                              SizedBox(height: 12),
                              Text(
                                '🕒 El tiempo total se basa en tus sesiones de estudio.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),

            // BOTTOM NAV CON HOVER SOLO PARA INICIO Y BÚSQUEDA
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Botón Inicio con hover
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => isHomeHovered = true),
                    onExit: (_) => setState(() => isHomeHovered = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()..scale(isHomeHovered ? 1.05 : 1.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.home,
                              color: isHomeHovered 
                                  ? Colors.blue 
                                  : Colors.grey,
                              size: isHomeHovered ? 26 : 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Inicio',
                              style: TextStyle(
                                fontSize: isHomeHovered ? 13 : 12,
                                color: isHomeHovered 
                                    ? Colors.blue 
                                    : Colors.grey,
                                fontWeight: isHomeHovered 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Botón Buscar con hover
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => isSearchHovered = true),
                    onExit: (_) => setState(() => isSearchHovered = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()..scale(isSearchHovered ? 1.05 : 1.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/busqueda');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search,
                              color: isSearchHovered 
                                  ? Colors.blue 
                                  : Colors.grey,
                              size: isSearchHovered ? 26 : 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Buscar',
                              style: TextStyle(
                                fontSize: isSearchHovered ? 13 : 12,
                                color: isSearchHovered 
                                    ? Colors.blue 
                                    : Colors.grey,
                                fontWeight: isSearchHovered 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Botón Progreso SIN hover (se mantiene igual)
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bar_chart,
                          color: Color(0xFFFF8C42),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Progreso',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF8C42),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CÍRCULO
  Widget progressCircle({
    required double percent,
    required Color color,
    required String text,
    required String label,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 130,
          height: 130,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 12,
                  color: color,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 26,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}