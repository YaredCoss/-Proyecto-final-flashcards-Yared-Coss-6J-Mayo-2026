import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  // 👤 usuarios en tiempo real
  Stream<int> usersCount() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((s) => s.docs.length);
  }

  // 🃏 tarjetas en tiempo real
  Stream<int> cardsCount() {
    return FirebaseFirestore.instance
        .collection('cards')
        .snapshots()
        .map((s) => s.docs.length);
  }

  // 🚨 reportados en tiempo real
  Stream<int> reportedDecksCount() {
    return FirebaseFirestore.instance
        .collection('decks')
        .where('reported', isEqualTo: true)
        .snapshots()
        .map((s) => s.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Column(
        children: [

          // APPBAR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            color: const Color(0xFF424242),
            child: const Text(
              "Panel Admin",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  // 📦 DATOS CRÍTICOS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Datos críticos",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                          ),
                        ),

                        const SizedBox(height: 12),

                        StreamBuilder<int>(
                          stream: usersCount(),
                          builder: (context, snapshot) {
                            return Text(
                              "Total usuarios: ${snapshot.data ?? 0}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 8),

                        StreamBuilder<int>(
                          stream: cardsCount(),
                          builder: (context, snapshot) {
                            return Text(
                              "Tarjetas creadas: ${snapshot.data ?? 0}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🚨 REPORTADOS (DINÁMICO)
                  StreamBuilder<int>(
                    stream: reportedDecksCount(),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;

                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8C42),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/admin/reportados",
                            );
                          },
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.warning,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Ver mazos reportados",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.white,
                                child: Text(
                                  "$count",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFFF8C42),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 🔴 CERRAR SESIÓN
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/");
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      minimumSize:
                          const Size(double.infinity, 50),
                    ),
                    child: const Text("Cerrar Sesión"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}