import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final TextEditingController usuarioController =
      TextEditingController();

  final TextEditingController nombreController =
      TextEditingController();

  final TextEditingController apellidoController =
      TextEditingController();

  final TextEditingController correoController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController
      confirmPasswordController =
      TextEditingController();

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

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),

        borderSide: const BorderSide(
          color: Color(0xFFD6D6D6),
        ),
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
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 420,
            ),

            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,

                  children: [

                    const SizedBox(
                      height: 20,
                    ),

                    // TÍTULO
                    const Text(
                      'Registro',

                      style: TextStyle(
                        fontSize: 34,
                        color:
                            Color(0xFF333333),
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    // INPUTS
                    TextField(
                      controller:
                          usuarioController,

                      decoration:
                          inputStyle(
                        'Usuario',
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller:
                          nombreController,

                      decoration:
                          inputStyle(
                        'Nombre',
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller:
                          apellidoController,

                      decoration:
                          inputStyle(
                        'Apellido',
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                        controller: correoController,
                        decoration: inputStyle('Correo'),
                        ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller:
                          passwordController,

                      obscureText: true,

                      decoration:
                          inputStyle(
                        'Contraseña',
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller:
                          confirmPasswordController,

                      obscureText: true,

                      decoration:
                          inputStyle(
                        'Confirmar contraseña',
                      ),
                    ),

                    const SizedBox(
                      height: 36,
                    ),

                    // BOTÓN
                    ElevatedButton(
                      onPressed: () async {

                        // VALIDAR CONTRASEÑAS
                        if (passwordController.text !=
                            confirmPasswordController.text) {

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Las contraseñas no coinciden',
                              ),
                            ),
                          );

                          return;
                        }

                        try {

                          // CREAR USUARIO EN AUTH
                          final credential =
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                            email:
                                correoController.text.trim(),
                            password:
                                passwordController.text.trim(),
                          );

                          final user = credential.user;

                          if (user == null) return;

                          // GUARDAR EN FIRESTORE
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .set({

                            'username':
                                usuarioController.text.trim(),

                            'nombre':
                                nombreController.text.trim(),

                            'apellido':
                                apellidoController.text.trim(),

                            'email': user.email,

                            'role': 'user',

                            'streak': 0,
                            'dailyGoal': 20,
                            'reviewedToday': 0,

                            'lastStudyDate':
                                Timestamp.now(),

                            'createdAt':
                                Timestamp.now(),
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Cuenta creada correctamente',
                              ),
                            ),
                          );

                          Navigator.pushReplacementNamed(
                            context,
                            '/home',
                          );

                        } on FirebaseAuthException catch (e) {

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                e.message ??
                                    'Error al registrarse',
                              ),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFF8C42),

                        foregroundColor:
                            Colors.white,

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),

                      child: const Text(
                        'Crear cuenta',

                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        const Text(
                          '¿Ya tienes una cuenta?',
                          style: TextStyle(
                            color: Color(0xFF666666),
                          ),
                        ),

                        TextButton(
                          onPressed: () {

                            Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            );
                          },

                          child: const Text(
                            'Inicia sesión',

                            style: TextStyle(
                              color: Color(0xFFFF8C42),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}