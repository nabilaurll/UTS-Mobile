import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'signup_page.dart';
import 'theater_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchLoginData();
  }

  Future<void> fetchLoginData() async {
    try {
      final response = await http.get(
        Uri.parse('https://mocki.io/v1/8a421234-bcb1-4d35-b825-ff68e22b4e0a'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          imageUrl = data['image'];
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          // 🔹 Background image dari API
          if (imageUrl != null)
            Positioned.fill(child: Image.network(imageUrl!, fit: BoxFit.cover))
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.amberAccent),
            ),

          // 🔹 Overlay biar form jelas
          Container(color: Colors.black.withOpacity(0.55)),

          // 🔹 Form login
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 220),

                _buildInputField(Icons.email_outlined, 'Email'),
                const SizedBox(height: 16),
                _buildInputField(
                  Icons.lock_outline,
                  'Password',
                  isPassword: true,
                ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.poppins(color: Colors.lightBlueAccent),
                  ),
                ),

                const SizedBox(height: 24),
                _mainButton(context, "Login", const TheaterPage()),

                const SizedBox(height: 24),
                Text("Or", style: GoogleFonts.poppins(color: Colors.white70)),

                const SizedBox(height: 20),
                _socialButton(
                  "Login with Google",
                  const Color(0xFF2B2A6A).withOpacity(0.7),
                  Colors.white,
                  Icons.g_mobiledata,
                ),
                const SizedBox(height: 12),
                _socialButton(
                  "Login with Facebook",
                  const Color(0xFF2B2A6A).withOpacity(0.7),
                  Colors.white,
                  Icons.facebook,
                ),

                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()),
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "Don’t have an account? ",
                      style: GoogleFonts.poppins(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: "Register here",
                          style: GoogleFonts.poppins(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String hint, {
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _mainButton(BuildContext context, String text, Widget page) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2B2A6A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _socialButton(
    String text,
    Color color,
    Color textColor,
    IconData icon,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          side: const BorderSide(color: Colors.white30),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        icon: Icon(icon, color: textColor, size: 26),
        label: Text(
          text,
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
