import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'study_screen.dart';

class SessionResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final String deckTitle;
  final String deckId;
  final List<Map<String, dynamic>> wrongCards;

  const SessionResultScreen({
    super.key,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.deckId,
    required this.deckTitle, // 🔥 FALTABA ESTO
    required this.wrongCards,
  });

  // 🚨 REPORTAR MAZO (Firestore)
  Future<void> _reportDeck() async {
    await FirebaseFirestore.instance
        .collection('decks')
        .doc(deckId)
        .set({
          'name': deckTitle,
          'reported': true,
          'reportedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  // 🚨 DIÁLOGO DE CONFIRMACIÓN
  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reportar mazo"),
          content: const Text(
            "¿Estás seguro de que deseas reportar este mazo? Un administrador lo revisará.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await _reportDeck();
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Mazo reportado correctamente 🚨"),
                  ),
                );
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = correctAnswers + wrongAnswers;

    final correctPercent = total == 0 ? 0.0 : correctAnswers / total;
    final wrongPercent = total == 0 ? 0.0 : wrongAnswers / total;

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
                vertical: 24,
              ),
              child: const Center(
                child: Text(
                  '¡Sesión Terminada!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // TARJETA RESULTADOS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [

                          const Text(
                            '¡Excelente trabajo!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              color: Color(0xFFFF8C42),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 36),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              resultCircle(
                                color: Colors.green,
                                icon: Icons.check,
                                title: 'Acertadas',
                                value: '$correctAnswers/$total',
                                percent: correctPercent,
                              ),

                              resultCircle(
                                color: Colors.red,
                                icon: Icons.close,
                                title: 'Falladas',
                                value: '$wrongAnswers/$total',
                                percent: wrongPercent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔥 BOTÓN REPORTAR MAZO
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _showReportDialog(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          "Reportar mazo",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // VOLVER
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8C42),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Volver al inicio',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // REPASAR FALLADAS
                    if (wrongCards.isNotEmpty && wrongAnswers > 0)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {

                            Navigator.pushReplacement(
                              context,

                              MaterialPageRoute(
                                builder: (_) => StudyScreen(

                                  deckId: deckId,
                                  deckTitle: deckTitle,

                                  reviewCards: wrongCards,
                                ),
                              ),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,

                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18),
                            ),
                          ),

                          child: const Text(
                            'Repasar falladas',

                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget resultCircle({
    required Color color,
    required IconData icon,
    required String title,
    required String value,
    required double percent,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Icon(icon, size: 40, color: color),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}