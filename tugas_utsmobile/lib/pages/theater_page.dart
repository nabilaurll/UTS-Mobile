import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TheaterPage extends StatelessWidget {
  const TheaterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> theaters = [
      "XI CINEMA",
      "PONDOK KELAPA 21",
      "CGV",
      "CINEPOLIS",
      "CP MALL",
      "HERMES",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("THEATER"),
        backgroundColor: const Color(0xFF2B2A6A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on, color: Colors.amber),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: "MEDAN",
              items: const [
                DropdownMenuItem(value: "MEDAN", child: Text("MEDAN")),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: theaters.length,
                itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      theaters[index],
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    children: const [ListTile(title: Text("Tiket tersedia"))],
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
