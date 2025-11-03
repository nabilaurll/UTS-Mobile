import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'theater_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchSignupData();
  }

  Future<void> fetchSignupData() async {
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

          // 🔹 Overlay transparan biar teks jelas
          Container(color: Colors.black.withOpacity(0.55)),

          // 🔹 Form signup
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 200),

                _buildInputField(Icons.person_outline, 'Full Name'),
                const SizedBox(height: 16),
                _buildInputField(Icons.email_outlined, 'Email'),
                const SizedBox(height: 16),
                _buildInputField(
                  Icons.lock_outline,
                  'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  Icons.lock_outline,
                  'Confirm Password',
                  isPassword: true,
                ),

                const SizedBox(height: 30),
                _mainButton(context, "Sign Up", const TheaterPage()),

                const SizedBox(height: 25),
                Text("Or", style: GoogleFonts.poppins(color: Colors.white70)),

                const SizedBox(height: 20),
                _socialButton(
                  "Sign up with Google",
                  const Color(0xFF2B2A6A).withOpacity(0.7),
                  Colors.white,
                  Icons.g_mobiledata,
                ),
                const SizedBox(height: 12),
                _socialButton(
                  "Sign up with Facebook",
                  const Color(0xFF2B2A6A).withOpacity(0.7),
                  Colors.white,
                  Icons.facebook,
                ),

                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.poppins(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: "Login here",
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
