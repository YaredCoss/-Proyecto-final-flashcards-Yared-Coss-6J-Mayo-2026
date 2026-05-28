import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'session_result_screen.dart';

class StudyScreen extends StatefulWidget {

  final String deckId;
  final String deckTitle;
  final List<Map<String, dynamic>>? reviewCards;

  const StudyScreen({
    super.key,
    required this.deckId,
    required this.deckTitle,
    this.reviewCards,
  });

  @override
  State<StudyScreen> createState() =>
      _StudyScreenState();
}

class _StudyScreenState
    extends State<StudyScreen> {

  int currentIndex = 0;

  int correctAnswers = 0;
  int incorrectAnswers = 0;

  List<dynamic> cards = [];

  List<Map<String, dynamic>>
      failedCards = [];

  bool loading = true;

  String? selectedOption;

  bool answered = false;

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  Future<void> loadCards() async {

  // REPASO DE FALLADAS
    if (widget.reviewCards != null) {

      cards = widget.reviewCards!;

      setState(() {
        loading = false;
      });

      return;
    }

    // NORMAL
    final snapshot =
        await FirebaseFirestore.instance
            .collection('cards')
            .where(
              'deckId',
              isEqualTo: widget.deckId,
            )
            .get();

    cards = snapshot.docs;

    setState(() {
      loading = false;
    });
  }

  void nextCard() {

    if (currentIndex < cards.length - 1) {

      setState(() {

        currentIndex++;

        selectedOption = null;

        answered = false;
      });

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SessionResultScreen(
            correctAnswers:
                correctAnswers,

            wrongAnswers:
                incorrectAnswers,

            wrongCards:
                failedCards,

            deckId:
                widget.deckId,

            deckTitle:
                widget.deckTitle,
          ),
        ),
      );
    }
  }

  void previousCard() {

    if (currentIndex > 0) {

      setState(() {

        currentIndex--;

        selectedOption = null;

        answered = false;

      });
    }
  }

  Future<void> checkAnswer(
    String selectedOption,
  ) async {

    if (answered) return;

    final currentCard =
        cards[currentIndex];

    final correctAnswer =
        currentCard['correctAnswer']
            .toString()
            .trim()
            .toLowerCase();

    final selected =
        selectedOption
            .trim()
            .toLowerCase();

    setState(() {

      this.selectedOption =
          selectedOption;

      answered = true;
    });

    // CORRECTA
    if (selected == correctAnswer) {

      correctAnswers++;

      await Future.delayed(
        const Duration(
          milliseconds: 700,
        ),
      );

      nextCard();

      return;
    }

    // INCORRECTA
    failedCards.add({

      'front':
          currentCard['front'],

      'correctAnswer':
          currentCard['correctAnswer'],

      'options':
          List<String>.from(
            currentCard['options'],
          ),
    });

    incorrectAnswers++;

    await Future.delayed(
      const Duration(
        milliseconds: 700,
      ),
    );

    nextCard();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      body: SafeArea(

        child: loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )

            : cards.isEmpty
                ? const Center(
                    child: Text(
                      'Este mazo no tiene tarjetas',
                    ),
                  )

                : Column(
                    children: [

                      // APPBAR
                      Container(
                        width: double.infinity,

                        color: const Color(
                          0xFF424242,
                        ),

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),

                        child: const Center(
                          child: Text(
                            '¡A estudiar!',

                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                         child: SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                              24,
                            ),

                            child: Column(

                              children: [

                                // TARJETA
                                Container(
                                  width:
                                      double.infinity,

                                  constraints:
                                      const BoxConstraints(
                                    minHeight: 260,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        Colors.blue,

                                    borderRadius:
                                        BorderRadius.circular(
                                      32,
                                    ),
                                  ),

                                  child: Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(
                                        20,
                                      ),

                                      child: Text(
                                        cards[
                                                currentIndex]
                                            ['front'],

                                        textAlign:
                                            TextAlign
                                                .center,

                                        style:
                                            const TextStyle(
                                          color:
                                              Colors
                                                  .white,
                                          fontSize:
                                              42,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 30,
                                ),

                                Column(

                                  children: List.generate(

                                    List<String>.from(
                                      cards[currentIndex]['options'],
                                    ).length,

                                    (index) {

                                      final option =
                                          cards[currentIndex]['options'][index];


                                      Color buttonColor = Colors.white;
                                      Color textColor = const Color(0xFF333333);

                                      if (answered) {

                                        final isCorrect =
                                            option
                                                .trim()
                                                .toLowerCase() ==

                                            cards[currentIndex]
                                                ['correctAnswer']
                                                .toString()
                                                .trim()
                                                .toLowerCase();

                                        final isSelected =
                                            option == selectedOption;

                                        if (isCorrect) {

                                          buttonColor = Colors.green;
                                          textColor = Colors.white;

                                        } else if (isSelected) {

                                          buttonColor = Colors.red;
                                          textColor = Colors.white;
                                        }
                                      }

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(
                                          bottom: 14,
                                        ),

                                        child: SizedBox(
                                          width: double.infinity,

                                          child: ElevatedButton(

                                            onPressed: () {

                                              if (!answered) {
                                                checkAnswer(option);
                                              }
                                            },

                                            style:
                                                ElevatedButton.styleFrom(

                                              backgroundColor: buttonColor,

                                              foregroundColor: textColor,

                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 18,
                                              ),

                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  18,
                                                ),
                                              ),
                                            ),

                                            child: AnimatedSwitcher(

                                              duration: const Duration(
                                                milliseconds: 250,
                                              ),

                                              child: Text(
                                                option,

                                                key: ValueKey(option),

                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(
                                  height: 28,
                                ),
                                const SizedBox(
                                  height: 20,
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