import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool isHomeHovered = false;
  bool isSearchHovered = false;
  bool isProgressHovered = false;

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
                'Nosotros',
                textAlign: TextAlign.center,
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
                  children: [
                    // TARJETA PRINCIPAL
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Flashcard Pro',
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(0xFFFF8C42),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Somos una plataforma dedicada a revolucionar la forma en que estudias. Nuestra misión es hacer que el aprendizaje sea más efectivo, divertido y accesible para todos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Con nuestra tecnología de repetición espaciada y diseño intuitivo, ayudamos a estudiantes de todo el mundo a alcanzar sus metas académicas.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // EQUIPO
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Nuestro Equipo',
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 20),
                          teamItem('Desarrolladores apasionados'),
                          teamItem('Diseñadores creativos'),
                          teamItem('Educadores experimentados'),
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              '• Expertos en UX/UI',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BOTTOM NAVIGATION CON HOVER
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.black12,
                  ),
                ),
              ),
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
                              color: isHomeHovered 
                                  ? Colors.blue 
                                  : const Color(0xFF666666),
                              size: isHomeHovered ? 26 : 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Inicio',
                              style: TextStyle(
                                fontSize: isHomeHovered ? 13 : 12,
                                color: isHomeHovered 
                                    ? Colors.blue 
                                    : const Color(0xFF666666),
                                fontWeight: isHomeHovered 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Botón Buscar con hover
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => isSearchHovered = true),
                    onExit: (_) => setState(() => isSearchHovered = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()..scale(isSearchHovered ? 1.05 : 1.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/busqueda');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search,
                              color: isSearchHovered 
                                  ? Colors.blue 
                                  : const Color(0xFF666666),
                              size: isSearchHovered ? 26 : 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Buscar',
                              style: TextStyle(
                                fontSize: isSearchHovered ? 13 : 12,
                                color: isSearchHovered 
                                    ? Colors.blue 
                                    : const Color(0xFF666666),
                                fontWeight: isSearchHovered 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              color: isProgressHovered 
                                  ? Colors.blue 
                                  : const Color(0xFF666666),
                              size: isProgressHovered ? 26 : 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Progreso',
                              style: TextStyle(
                                fontSize: isProgressHovered ? 13 : 12,
                                color: isProgressHovered 
                                    ? Colors.blue 
                                    : const Color(0xFF666666),
                                fontWeight: isProgressHovered 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
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

  // ITEM EQUIPO
  Widget teamItem(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      child: Text(
        '• $text',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }
}