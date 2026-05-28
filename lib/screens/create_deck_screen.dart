import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateDeckScreen extends StatefulWidget {
  const CreateDeckScreen({super.key});

  @override
  State<CreateDeckScreen> createState() =>
      _CreateDeckScreenState();
}

class _CreateDeckScreenState
    extends State<CreateDeckScreen> {

  final TextEditingController
      titleController =
      TextEditingController();

  final TextEditingController
      descriptionController =
      TextEditingController();

  bool isLoading = false;

  Future<void> createDeck() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final title =
        titleController.text.trim();

    final description =
        descriptionController.text.trim();

    if (title.isEmpty ||
        description.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Completa todos los campos',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      // OBTENER DATOS USUARIO
      final userDoc =
          await FirebaseFirestore
              .instance
              .collection('users')
              .doc(user.uid)
              .get();

      final userData =
          userDoc.data() ?? {};

      final ownerName =
          userData['username'] ??
              'Usuario';

      // CREAR MAZO
      await FirebaseFirestore
          .instance
          .collection('decks')
          .add({

        'title': title,

        'description':
            description,

        'ownerId': user.uid,

        'ownerName':
            ownerName,

        'cardsCount': 0,

        'cards': [],

        'reported': false,

        'createdAt':    
            Timestamp.now(),
      });

      // AUMENTAR TARJETAS CREADAS
      await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .update({

        'totalCardsCreated':
            FieldValue.increment(1),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Mazo creado'),
        ),
      );

      Navigator.pushNamed(
        context,
        '/home',
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      body: SafeArea(
        child: Column(
          children: [

            // APPBAR
            Container(
              width: double.infinity,

              color:
                  const Color(0xFF424242),

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 22,
              ),

              child: const Text(
                'Crear Mazo',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),

            // CONTENIDO
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(
                  24,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,

                  children: [

                    // TÍTULO
                    const Text(
                      'Título del mazo',

                      style: TextStyle(
                        color:
                            Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    TextField(
                      controller:
                          titleController,

                      decoration:
                          InputDecoration(
                        filled: true,
                        fillColor:
                            Colors.white,

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),

                          borderSide:
                              const BorderSide(
                            color: Colors
                                .grey,
                          ),
                        ),

                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),

                          borderSide:
                              const BorderSide(
                            color: Color(
                              0xFFFF8C42,
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    // DESCRIPCIÓN
                    const Text(
                      'Descripción',

                      style: TextStyle(
                        color:
                            Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    TextField(
                      controller:
                          descriptionController,

                      maxLines: 5,

                      decoration:
                          InputDecoration(
                        filled: true,
                        fillColor:
                            Colors.white,

                        contentPadding:
                            const EdgeInsets.all(
                          20,
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),

                          borderSide:
                              const BorderSide(
                            color: Colors
                                .grey,
                          ),
                        ),

                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),

                          borderSide:
                              const BorderSide(
                            color: Color(
                              0xFFFF8C42,
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    // BOTÓN
                    ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : createDeck,

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
                          vertical: 18,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),

                      child:
                          isLoading
                              ? const SizedBox(
                                  width:
                                      24,
                                  height:
                                      24,

                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        Colors.white,

                                    strokeWidth:
                                        2,
                                  ),
                                )
                              : const Text(
                                  'Guardar',

                                  style:
                                      TextStyle(
                                    fontSize:
                                        18,
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),

            // NAV
            Container(
              padding:
                  const EdgeInsets.symmetric(
                vertical: 20,
              ),

              decoration:
                  const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        Colors.black12,
                  ),
                ),
              ),

              child: Center(
                child: GestureDetector(
                  onTap: () {

                    Navigator.pushNamed(
                      context,
                      '/home',
                    );
                  },

                  child: const Column(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [

                      Icon(
                        Icons.home,

                        color:
                            Colors.blue,
                      ),

                      SizedBox(height: 6),

                      Text(
                        'Inicio',

                        style: TextStyle(
                          color:
                              Colors.blue,
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
    );
  }
}