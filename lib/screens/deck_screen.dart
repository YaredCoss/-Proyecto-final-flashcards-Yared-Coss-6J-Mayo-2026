import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeckScreen extends StatefulWidget {
  final String deckId;
  final String deckTitle;

  const DeckScreen({
    super.key,
    required this.deckId,
    required this.deckTitle,
  });

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  bool isHomeHovered = false;
  bool isDeleteHovered = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {},
        onExit: (_) {},
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFF8C42),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/anadir-tarjeta',
              arguments: {
                'deckId': widget.deckId,
              },
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.deckTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                  
                  // Botón de basura circular con hover
                  StatefulBuilder(
                    builder: (context, setStateDelete) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) {
                          setStateDelete(() {
                            isDeleteHovered = true;
                          });
                        },
                        onExit: (_) {
                          setStateDelete(() {
                            isDeleteHovered = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Eliminar mazo'),
                                      content: const Text(
                                        '¿Seguro que quieres eliminar este mazo y todas sus tarjetas?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text(
                                            'Eliminar',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm != true) return;

                                final cards = await FirebaseFirestore.instance
                                    .collection('cards')
                                    .where('deckId', isEqualTo: widget.deckId)
                                    .get();

                                for (var doc in cards.docs) {
                                  await doc.reference.delete();
                                }

                                await FirebaseFirestore.instance
                                    .collection('decks')
                                    .doc(widget.deckId)
                                    .delete();

                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(context, '/home');
                                }
                              },
                              customBorder: const CircleBorder(),
                              hoverColor: Colors.red.withOpacity(0.2),
                              splashColor: Colors.red.withOpacity(0.3),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.delete,
                                  color: isDeleteHovered ? Colors.red : Colors.white,
                                  size: isDeleteHovered ? 28 : 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // TARJETAS - TAMAÑO MÁS PEQUEÑO CON HOVER
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('cards')
                      .where('deckId', isEqualTo: widget.deckId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay tarjetas todavía',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    final cards = snapshot.data!.docs;
                    
                    return GridView.builder(
                      itemCount: cards.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return CardWithHover(
                          cardId: card.id,
                          front: card['front'],
                          correctAnswer:
                              card['correctAnswer'],

                          options:
                              List<String>.from(
                                card['options'],
                              ),
                          deckId: widget.deckId,
                          deckTitle: widget.deckTitle,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            
            // NAVEGACIÓN INFERIOR CON HOVER
            StatefulBuilder(
              builder: (context, setStateHome) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) {
                    setStateHome(() {
                      isHomeHovered = true;
                    });
                  },
                  onExit: (_) {
                    setStateHome(() {
                      isHomeHovered = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 0,
                    ),
                    decoration: BoxDecoration(
                      color: isHomeHovered ? Colors.blue.withOpacity(0.1) : Colors.white,
                      border: const Border(
                        top: BorderSide(
                          color: Colors.black12,
                          width: 1,
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            color: isHomeHovered ? Colors.blue.shade700 : Colors.blue,
                            size: isHomeHovered ? 32 : 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Inicio',
                            style: TextStyle(
                              color: isHomeHovered ? Colors.blue.shade700 : Colors.blue,
                              fontSize: isHomeHovered ? 15 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de carta con efecto hover
class CardWithHover extends StatefulWidget {
  final String cardId;
  final String front;
  final String correctAnswer;
  final List<String> options;
  final String deckId;
  final String deckTitle;

  const CardWithHover({
    super.key,
    required this.cardId,
    required this.front,
    required this.correctAnswer,
    required this.options,
    required this.deckId,
    required this.deckTitle,
  });

  @override
  State<CardWithHover> createState() => _CardWithHoverState();
}

class _CardWithHoverState extends State<CardWithHover> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/editar-tarjeta',
            arguments: {
              'cardId': widget.cardId,
              'front': widget.front,
              'correctAnswer': widget.correctAnswer,
              'options': widget.options,
              'deckId': widget.deckId,
              'deckTitle': widget.deckTitle,
            },
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFFFF8C42).withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: isHovered ? 12 : 6,
                color: Colors.black.withOpacity(isHovered ? 0.15 : 0.08),
                offset: Offset(0, isHovered ? 4 : 2),
              ),
            ],
            border: isHovered 
                ? Border.all(
                    color: const Color(0xFFFF8C42),
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Frente:',
                style: TextStyle(
                  color: isHovered ? const Color(0xFFFF8C42) : Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.front,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isHovered ? 20 : 18,
                  color: isHovered ? const Color(0xFFFF8C42) : const Color(0xFF333333),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}