import 'package:flutter/material.dart';
// Sesuaikan import ini dengan nama layar utamamu nanti
import '../motivations/motivation_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() {
    setState(() => _isLoading = true);

    // Hardcode autentikasi sesuai syarat praktikum
    Future.delayed(const Duration(seconds: 1), () {
      if (_usernameController.text == 'admin' &&
          _passwordController.text == 'admin123') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MotivationScreen()),
        );
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kredensial salah."),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.remove_red_eye_outlined, size: 80, color: Color(0xFFD4AF37)),
              const SizedBox(height: 16),
              const Text(
                "Tavern of Secrets",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37)),
              ),
              const SizedBox(height: 8),
              const Text("Buktikan identitasmu untuk melihat Jalur Ilahi.", style: TextStyle(color: Colors.white60)),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Codename / Username"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Secret Passcode"),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Enter the Fog", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}