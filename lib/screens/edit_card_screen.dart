import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCardScreen extends StatefulWidget {

  final String cardId;
  final String front;
  final String correctAnswer;
  final List<String> options;

  const EditCardScreen({
    super.key,
    required this.cardId,
    required this.front,
    required this.correctAnswer,
    required this.options,
  });

  @override
  State<EditCardScreen> createState() =>
      _EditCardScreenState();
}

class _EditCardScreenState
    extends State<EditCardScreen> {

  late TextEditingController frontController;
  late TextEditingController correctAnswerController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    frontController =
        TextEditingController(
      text: widget.front,
    );

    correctAnswerController =
        TextEditingController(
      text: widget.correctAnswer,
    );
  }

  Future<void> updateCard() async {

    final front =
        frontController.text.trim();

    final correctAnswer =
        correctAnswerController.text.trim();

    if (front.isEmpty || correctAnswer.isEmpty) {

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

        final updatedOptions =
            List<String>.from(widget.options);

        if (!updatedOptions.contains(correctAnswer)) {
          updatedOptions.add(correctAnswer);
        }

        await FirebaseFirestore.instance
            .collection('cards')
            .doc(widget.cardId)
            .update({

          'front': front,
          'correctAnswer': correctAnswer,
          'options': updatedOptions,
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Tarjeta actualizada',
            ),
          ),
        );

        Navigator.pop(context);

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

  InputDecoration inputStyle(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,

      filled: true,
      fillColor: Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),

        borderSide: const BorderSide(
          color: Color(0xFFFF8C42),
          width: 2,
        ),
      ),
    );
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

              color:
                  const Color(0xFF424242),

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 22,
              ),

              child: const Text(
                'Editar Tarjeta',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),

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

                    TextField(
                      controller:
                          frontController,

                      decoration:
                          inputStyle(
                        'Frente',
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    TextField(
                      controller:
                          correctAnswerController,

                      decoration:
                          inputStyle(
                        'Respuesta correcta',
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : updateCard,

                      style:
                          ElevatedButton.styleFrom(
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
                              ? const CircularProgressIndicator(
                                  color:
                                      Colors.white,
                                )
                              : const Text(
                                  'Guardar Cambios',
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
}