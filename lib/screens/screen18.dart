import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Screen18 extends StatelessWidget {

  final String deckId;

  const Screen18({
    super.key,
    required this.deckId,
  });

  // OBTENER TARJETAS DEL MAZO
  Stream<List<QueryDocumentSnapshot>> getCards() {

    return FirebaseFirestore.instance
        .collection('cards')
        .where(
          'deckId',
          isEqualTo: deckId,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs;
    });
  }

  // ELIMINAR MAZO
  Future<void> deleteDeck(
    BuildContext context,
  ) async {

    // ELIMINAR TARJETAS DEL MAZO
    final cardsSnapshot =
        await FirebaseFirestore.instance
            .collection('cards')
            .where(
              'deckId',
              isEqualTo: deckId,
            )
            .get();

    for (var doc in cardsSnapshot.docs) {

      await FirebaseFirestore.instance
          .collection('cards')
          .doc(doc.id)
          .delete();
    }

    // ELIMINAR MAZO
    await FirebaseFirestore.instance
        .collection('decks')
        .doc(deckId)
        .delete();

    Navigator.pop(context);
  }

  Future<void> ignoreReport(
    BuildContext context,
  ) async {

    await FirebaseFirestore.instance
        .collection('decks')
        .doc(deckId)
        .update({

      'reported': false,
    });

    Navigator.pushReplacementNamed(
      context,
      '/admin/reportados',
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      body: StreamBuilder<
          List<QueryDocumentSnapshot>>(

        stream: getCards(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final cards = snapshot.data!;

          return Column(
            children: [

              // APPBAR
              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),

                color: const Color(
                  0xFF424242,
                ),

                child: SafeArea(
                  bottom: false,

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

                      const SizedBox(
                        width: 8,
                      ),

                      const Text(
                        'Revisar Mazo',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    24,
                  ),

                  child: ListView(
                    children: [

                      // REPORTE
                      Container(
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(
                                0.05,
                              ),

                              blurRadius: 10,
                            ),
                          ],
                        ),

                        child: Row(
                          children: const [

                            Icon(
                              Icons.warning,
                              color: Colors.red,
                            ),

                            SizedBox(
                              width: 10,
                            ),

                            Text(
                              'Mazo reportado',

                              style: TextStyle(
                                color:
                                    Color(
                                  0xFF333333,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // TÍTULO
                      const Text(
                        'Vista previa de tarjetas',

                        style: TextStyle(
                          fontSize: 20,
                          color:
                              Color(
                            0xFF333333,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // TARJETAS
                      if (cards.isEmpty)

                        const Text(
                          'Este mazo no tiene tarjetas',

                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )

                      else

                        ...cards.map((doc) {

                          final card =
                              doc.data()
                                  as Map<String, dynamic>;

                          return Container(
                            margin:
                                const EdgeInsets.only(
                              bottom: 12,
                            ),

                            padding:
                                const EdgeInsets.all(
                              16,
                            ),

                            decoration:
                                BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(
                                    0.05,
                                  ),

                                  blurRadius: 6,
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  card['front'] ?? '',

                                  style:
                                      const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(
                                  card['back'] ?? '',

                                  style:
                                      const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                      const SizedBox(
                        height: 24,
                      ),

                      // ELIMINAR
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () {
                            deleteDeck(context);
                          },

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red,

                            foregroundColor:
                                Colors.white,

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),

                          child: const Text(
                            'Eliminar Mazo',
                          ),
                        ),
                      ),
                    const SizedBox(
                        height: 12,
                      ),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () {
                            ignoreReport(context);
                          },

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.grey.shade300,

                            foregroundColor:
                                Colors.black,

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),

                          child: const Text(
                            'Ignorar reporte',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}