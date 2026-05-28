import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchText = '';
  bool isHomeHovered = false;
  bool isProgressHovered = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: Column(
          children: [
            // APPBAR
            Container(
              width: double.infinity,
              color: const Color(0xFF424242),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: const Center(
                child: Text(
                  'Buscar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),

            // CONTENIDO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // SEARCH BAR
                    TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar mazos',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.grey),
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
                    // INFO
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.04),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🌎 Mazos públicos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Puedes estudiar mazos creados por otros usuarios.',
                          ),
                          SizedBox(height: 8),
                          Text(
                            '✅ Puedes estudiar e interactuar con ellos.',
                          ),
                          SizedBox(height: 8),
                          Text(
                            '❌ No puedes modificarlos ni borrarlos.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // RESULTADOS
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('decks')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final decks = snapshot.data!.docs.where((doc) {
                            final title = doc['title'].toString().toLowerCase();
                            return title.contains(searchText);
                          }).toList();
                          if (decks.isEmpty) {
                            return const Center(
                              child: Text('No se encontraron mazos'),
                            );
                          }
                          return ListView.builder(
                            itemCount: decks.length,
                            itemBuilder: (context, index) {
                              final deck = decks[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 18),
                                padding: const EdgeInsets.all(20),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.style,
                                          color: Color(0xFFFF8C42),
                                          size: 34,
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            deck['title'],
                                            style: const TextStyle(
                                              fontSize: 22,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '${deck['cardsCount']} tarjetas',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Creado por: ${deck['ownerName'] ?? 'Usuario'}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                        // AUMENTAR REPASADAS
                                          if (user != null) {
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user.uid)
                                                .update({

                                              'reviewedToday':
                                                  FieldValue.increment(1),
                                            });
                                          }

                                          if (!context.mounted) return;

                                          Navigator.pushNamed(
                                            context,
                                            '/estudiar',

                                            arguments: {
                                              'deckId': deck.id,
                                              'deckTitle': deck['title'],
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFFF8C42),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                        ),
                                        child: const Text(
                                          'Estudiar',
                                          style: TextStyle(fontSize: 18),
                                        ),
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

            // BOTTOM NAV CON HOVER SOLO PARA INICIO Y PROGRESO
          if (!keyboardOpen)
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
                              color: isHomeHovered ? Colors.blue : Colors.grey,
                              size: isHomeHovered ? 26 : 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Inicio',
                              style: TextStyle(
                                fontSize: isHomeHovered ? 13 : 12,
                                color: isHomeHovered ? Colors.blue : Colors.grey,
                                fontWeight:
                                    isHomeHovered ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Botón Buscar SIN hover (se mantiene igual)
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search,
                          color: Color(0xFFFF8C42),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Buscar',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF8C42),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botón Progreso con hover
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => isProgressHovered = true),
                    onExit: (_) => setState(() => isProgressHovered = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()..scale(isProgressHovered ? 1.05 : 1.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/progreso');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: isProgressHovered ? Colors.blue : Colors.grey,
                              size: isProgressHovered ? 26 : 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Progreso',
                              style: TextStyle(
                                fontSize: isProgressHovered ? 13 : 12,
                                color: isProgressHovered ? Colors.blue : Colors.grey,
                                fontWeight:
                                    isProgressHovered ? FontWeight.w600 : FontWeight.normal,
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
          ],
        ),
      ),
    );
  }
}