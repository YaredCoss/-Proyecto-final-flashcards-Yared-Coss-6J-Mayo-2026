import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateCardScreen extends StatefulWidget {
  final String deckId;
  final String deckTitle;

  const CreateCardScreen({
    super.key,
    required this.deckId,
    required this.deckTitle,
  });

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final TextEditingController frontController = TextEditingController();
  final TextEditingController correctAnswerController =
      TextEditingController();

  List<TextEditingController> optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  bool isLoading = false;

Future<void> saveCard() async {

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final front = frontController.text.trim();

  final correctAnswer =
      correctAnswerController.text.trim();

  final options = optionControllers
      .map((e) => e.text.trim())
      .toList();

  if (front.isEmpty || correctAnswer.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Completa todos los campos'),
      ),
    );

    return;
  }

  // VALIDAR OPCIONES VACÍAS
  if (options.any((option) => option.isEmpty)) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No dejes opciones vacías',
        ),
      ),
    );

    return;
  }

  // AGREGAR RESPUESTA CORRECTA
  if (!options.contains(correctAnswer)) {
    options.add(correctAnswer);
  }

  options.shuffle();

  setState(() {
    isLoading = true;
  });

  try {

    await FirebaseFirestore.instance
        .collection('cards')
        .add({

      'front': front,

      'correctAnswer': correctAnswer,

      'options': options,

      'deckId': widget.deckId,

      'ownerId': user.uid,

      'createdAt': Timestamp.now(),
    });

    await FirebaseFirestore.instance
        .collection('decks')
        .doc(widget.deckId)
        .update({

      'cardsCount':
          FieldValue.increment(1),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({

      'totalCardsCreated':
          FieldValue.increment(1),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarjeta creada'),
      ),
    );

    Navigator.pop(context);

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
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
              child: const Text(
                'Añadir Tarjeta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),

            // CONTENIDO
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // MAZO
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Mazo seleccionado',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.deckTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Color(0xFFFF8C42),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // PALABRA
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Palabra',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: frontController,
                      decoration: InputDecoration(
                        hintText: 'Ej: Apple',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF8C42),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // RESPUESTA CORRECTA
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Respuesta correcta',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: correctAnswerController,
                      decoration: InputDecoration(
                        hintText: 'Ej: Manzana',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF8C42),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // OPCIONES
                    const Text(
                      'Opciones',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'La respuesta correcta se agregará automáticamente si no está en las opciones.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Column(
                      children: [

                        ...List.generate(
                          optionControllers.length,
                          (index) {

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextField(

                                controller:
                                    optionControllers[index],

                                decoration: InputDecoration(

                                  hintText:
                                      'Opción ${index + 1}',

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

                                  focusedBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),

                                    borderSide:
                                        const BorderSide(
                                      color: Color(0xFFFF8C42),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(

                            onPressed: () {

                              setState(() {

                                optionControllers.add(
                                  TextEditingController(),
                                );
                              });
                            },

                            icon: const Icon(Icons.add),

                            label: const Text(
                              'Agregar opción',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // BOTÓN
                    ElevatedButton(
                      onPressed: isLoading ? null : saveCard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8C42),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Guardar Tarjeta',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                    ),
                    // Espacio adicional para que no se pegue al fondo
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // NAVEGACIÓN - COMPLETO Y VISIBLE
            Container(
              width: double.infinity, // Asegura que ocupe todo el ancho
              padding: const EdgeInsets.symmetric(
                vertical: 16, // Aumentado el padding vertical
                horizontal: 0,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                    width: 1.5, // Borde ligeramente más visible
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: Colors.blue,
                      size: 28, // Ícono más grande
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Inicio',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15, // Texto más grande
                        fontWeight: FontWeight.w500, // Un poco más grueso
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