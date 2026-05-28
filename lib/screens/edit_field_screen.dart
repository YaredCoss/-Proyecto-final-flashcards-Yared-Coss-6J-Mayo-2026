import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScreenEditFieldScreen extends StatefulWidget {
  final String field; // "username" o "email"

  const ScreenEditFieldScreen({
    super.key,
    required this.field,
  });

  @override
  State<ScreenEditFieldScreen> createState() =>
      _ScreenEditFieldScreenState();
}

class _ScreenEditFieldScreenState extends State<ScreenEditFieldScreen> {
  final user = FirebaseAuth.instance.currentUser;

  final TextEditingController oldValueController = TextEditingController();
  final TextEditingController newValueController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final data = doc.data() ?? {};

    final value = data[widget.field] ?? '';

    oldValueController.text = value;

    setState(() => loading = false);
  }

  Future<void> _updateField() async {
    if (user == null) return;

    final newValue = newValueController.text.trim();
    if (newValue.isEmpty) return;

    try {
      // 1. FIREBASE AUTH (solo email)
      if (widget.field == "email") {
        await user!.updateEmail(newValue);
      }

      // 2. FIRESTORE (siempre)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        widget.field: newValue,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Actualizado correctamente")),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      // fallback: solo Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        widget.field: newValue,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Actualizado en base de datos (Auth falló)"),
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  String get title {
    return widget.field == "email" ? "Editar correo" : "Editar usuario";
  }

  String get oldLabel {
    return widget.field == "email"
        ? "Correo actual"
        : "Usuario actual";
  }

  String get newLabel {
    return widget.field == "email"
        ? "Nuevo correo"
        : "Nuevo usuario";
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF424242),
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const SizedBox(height: 10),

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: oldValueController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: oldLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: newValueController,
                      decoration: InputDecoration(
                        labelText: newLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8C42),
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: _updateField,
                        child: const Text("Confirmar"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}