import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Screen17 extends StatelessWidget {
  const Screen17({super.key});

  Stream<List<Map<String, dynamic>>> getReportedDecks() {
    return FirebaseFirestore.instance
        .collection('decks')
        .where('reported', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? 'Sin nombre',
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [

          // APPBAR

          IconButton(
            onPressed: () {
                Navigator.pop(context);
            },

            icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
            ),
            ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            color: const Color(0xFF424242),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  "Panel Admin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // SUBTÍTULO
                  const Text(
                    "Mazos reportados",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF333333),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // LISTA DINÁMICA
                  Expanded(
                    child: StreamBuilder<
                        List<Map<String, dynamic>>>(
                      stream: getReportedDecks(),
                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final decks = snapshot.data!;

                        // 🔥 si no hay reportados → no mostrar nada
                        if (decks.isEmpty) {
                          return const SizedBox();
                        }

                        return ListView.builder(
                          itemCount: decks.length,
                          itemBuilder: (context, index) {
                            final mazo = decks[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
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
                              child: Row(
                                children: [

                                  // ICONO
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.warning,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // INFO
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Mazo: ${mazo['name']}",
                                          style: const TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          "Reportado",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // BOTÓN
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/admin/revisar',

                                        arguments: {
                                          'id': mazo['id'],
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFFFF8C42),
                                      foregroundColor: Colors.white,
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "Revisar contenido",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
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