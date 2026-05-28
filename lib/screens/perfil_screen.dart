import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Screen12 extends StatefulWidget {
  const Screen12({super.key});

  @override
  State<Screen12> createState() => _Screen12State();
}

class _Screen12State extends State<Screen12> {
  final user = FirebaseAuth.instance.currentUser;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;

      usernameController.text = data['username'] ?? '';
      emailController.text = data['email'] ?? '';
    }

    setState(() => loading = false);
  }

  Future<void> _saveChanges() async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({
      'username': usernameController.text,
      'email': emailController.text,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF424242),
        title: const Text(
          "Perfil",
          style: TextStyle(color: Colors.white), // Título en blanco
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white, // Flecha de retroceso en blanco
          ),
          onPressed: () => Navigator.pushNamed(context, "/home"),
        ),
        // Opcional: también puedes cambiar el color del icono de acciones si las tuvieras
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),

              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),

              const SizedBox(height: 30),

              // Username
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Usuario",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C42),
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: _saveChanges,
                  child: const Text("Guardar cambios"),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/confirmar-cierre");
                  },
                  child: const Text("Cerrar sesión"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}