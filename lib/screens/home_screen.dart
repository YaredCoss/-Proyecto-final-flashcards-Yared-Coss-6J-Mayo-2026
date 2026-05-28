import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    final userDocStream = FirebaseFirestore
        .instance
        .collection('users')
        .doc(user?.uid)
        .snapshots();

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

                // APPBAR
                Container(
                  color: Colors.white,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [

                      IconButton(
                        onPressed: () {
                            Navigator.pushNamed(context, '/nosotros');
                        },

                        icon: const Icon(
                          Icons.settings,
                          color:
                              Color(0xFF333333),
                        ),
                      ),

                      const Text(
                        '¡Hola, Estudiante!',

                        style: TextStyle(
                          fontSize: 22,
                          color:
                              Color(0xFF333333),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                            Navigator.pushNamed(context, '/editar-perfil');
                        },

                        icon: const Icon(
                          Icons.person,
                          color:
                              Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),

                // CONTENIDO
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        24,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .stretch,

                        children: [

                          // STREAM USER
                          StreamBuilder<
                              DocumentSnapshot>(
                            stream:
                                userDocStream,

                            builder:
                                (
                              context,
                              snapshot,
                            ) {

                              if (!snapshot
                                  .hasData) {

                                return const Center(
                                  child:
                                      CircularProgressIndicator(),
                                );
                              }

                              final data =
                                  snapshot
                                          .data!
                                          .data()
                                      as Map<
                                          String,
                                          dynamic>;

                              final streak =
                                  data['streak'] ??
                                      0;

                              final reviewedToday =
                                  data['reviewedToday'] ??
                                      0;

                              final dailyGoal =
                                  data['dailyGoal'] ??
                                      20;

                              return Column(
                                children: [

                                  // TÍTULO
                                  const Text(
                                    'Tu progreso',

                                    textAlign:
                                        TextAlign
                                            .center,

                                    style:
                                        TextStyle(
                                      fontSize:
                                          30,

                                      color:
                                          Color(
                                        0xFF333333,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                        28,
                                  ),

                                  // TARJETAS
                                  Row(
                                    children: [

                                      Expanded(
                                        child:
                                            progressCard(
                                          icon:
                                              Icons.local_fire_department,

                                          title:
                                              'Racha:',

                                          value:
                                              '$streak días',
                                        ),
                                      ),

                                      const SizedBox(
                                        width:
                                            16,
                                      ),

                                      Expanded(
                                        child:
                                            progressCard(
                                          icon:
                                              Icons.book,

                                          title:
                                              'Repasadas:',

                                          value:
                                              '$reviewedToday/$dailyGoal',
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height:
                                        20,
                                  ),

                                  // INFO
                                  Container(
                                    width:
                                        double.infinity,

                                    padding:
                                        const EdgeInsets.all(
                                      18,
                                    ),

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          Colors
                                              .white,

                                      borderRadius:
                                          BorderRadius.circular(
                                        20,
                                      ),

                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius:
                                              6,

                                          color: Colors
                                              .black
                                              .withOpacity(
                                            0.04,
                                          ),
                                        ),
                                      ],
                                    ),

                                    child:
                                        const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [

                                        Text(
                                          '🔥 Racha',

                                          style:
                                              TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        SizedBox(
                                          height:
                                              4,
                                        ),

                                        Text(
                                          'Aumenta cuando completas tu objetivo diario.',
                                        ),

                                        SizedBox(
                                          height:
                                              12,
                                        ),

                                        Text(
                                          '📚 Repasadas',

                                          style:
                                              TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        SizedBox(
                                          height:
                                              4,
                                        ),

                                        Text(
                                          'Cantidad de tarjetas estudiadas hoy.',
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                        24,
                                  ),

                                  // BOTONES
                                  Row(
                                    children: [

                                      Expanded(
                                        child:
                                            orangeButton(
                                          'Progreso',
                                          () {
                                            Navigator.pushNamed(context, '/progreso');
                                          },
                                        ),
                                      ),

                                      const SizedBox(
                                        width:
                                            16,
                                      ),

                                      Expanded(
                                        child:
                                            orangeButton(
                                          'Estudiar',
                                          () {
                                            Navigator.pushNamed(context, '/busqueda');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height:
                                        32,
                                  ),

                                  const Divider(),

                                  const SizedBox(
                                    height:
                                        24,
                                  ),
                                ],
                              );
                            },
                          ),

                          // MIS MAZOS
                          const Text(
                            'Mis Mazos',

                            style: TextStyle(
                              fontSize: 24,
                              color:
                                  Color(
                                0xFF333333,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // STREAM MAZOS
                          StreamBuilder<
                              QuerySnapshot>(
                            stream:
                                FirebaseFirestore
                                    .instance
                                    .collection(
                                        'decks')
                                    .where(
                                      'ownerId',
                                      isEqualTo:
                                          user?.uid,
                                    )
                                    .snapshots(),

                            builder:
                                (
                              context,
                              snapshot,
                            ) {

                              if (snapshot
                                      .connectionState ==
                                  ConnectionState
                                      .waiting) {

                                return const Center(
                                  child:
                                      CircularProgressIndicator(),
                                );
                              }

                              if (!snapshot
                                      .hasData ||
                                  snapshot
                                      .data!
                                      .docs
                                      .isEmpty) {

                                return const Padding(
                                  padding:
                                      EdgeInsets.symmetric(
                                    vertical:
                                        40,
                                  ),

                                  child: Center(
                                    child:
                                        Text(
                                      'No tienes mazos todavía',

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.grey,

                                        fontSize:
                                            16,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final decks =
                                  snapshot
                                      .data!
                                      .docs;

                              return GridView
                                  .builder(
                                shrinkWrap:
                                    true,

                                physics:
                                    const NeverScrollableScrollPhysics(),

                                itemCount:
                                    decks.length,

                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2,

                                  crossAxisSpacing:
                                      16,

                                  mainAxisSpacing:
                                      16,

                                  childAspectRatio:
                                      0.9,
                                ),

                                itemBuilder:
                                    (
                                  context,
                                  index,
                                ) {

                                  final deck =
                                      decks[
                                          index];

                                  return InkWell(
                                    onTap: () {
                                        Navigator.pushNamed(
                                        context,
                                        '/mazo',
                                        arguments: {
                                            'id': deck.id,
                                            'title': deck['title'] ?? '',
                                        },
                                        );
                                    },
                                    child: deckCard(
                                        title: deck['title'] ?? '',
                                        cards: (deck.data() as Map<String, dynamic>)['cardsCount']?.toString() ?? '0',
                                    ),
                                    );
                                },
                              );
                            },
                          ),

                          const SizedBox(
                            height: 28,
                          ),

                          // CREAR MAZO
                          ElevatedButton.icon(
                            onPressed: () {
                                Navigator.pushNamed(context, '/crear-mazo');
                            },

                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  const Color(
                                0xFFFF8C42,
                              ),

                              foregroundColor:
                                  Colors.white,

                              padding:
                                  const EdgeInsets.symmetric(
                                vertical:
                                    18,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                              ),
                            ),

                            icon: const Icon(
                              Icons.add,
                            ),

                            label: const Text(
                              'Crear nuevo mazo',

                              style:
                                  TextStyle(
                                fontSize:
                                    18,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 24,
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

  // CARD PROGRESO
  Widget progressCard({
    required IconData icon,
    required String title,
    required String value,
  }) {

    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 8,

            color:
                Colors.black.withOpacity(
              0.05,
            ),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Icon(
            icon,

            color:
                const Color(0xFFFF8C42),

            size: 34,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            title,

            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            value,

            style: const TextStyle(
              fontSize: 24,

              color:
                  Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  // BOTÓN
  Widget orangeButton(
    String text,
    VoidCallback onPressed,
  ) {

    return ElevatedButton(
      onPressed: onPressed,

      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color(0xFFFF8C42),

        foregroundColor:
            Colors.white,

        padding:
            const EdgeInsets.symmetric(
          vertical: 16,
        ),

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),
      ),

      child: Text(text),
    );
  }

  // CARD MAZO
  Widget deckCard({
    required String title,
    required String cards,
  }) {

    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 8,

            color:
                Colors.black.withOpacity(
              0.05,
            ),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          const Icon(
            Icons.style,

            size: 42,

            color:
                Color(0xFFFF8C42),
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            title,

            textAlign:
                TextAlign.center,

            style: const TextStyle(
              fontSize: 18,

              color:
                  Color(0xFF333333),
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            '$cards tarjetas',

            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}