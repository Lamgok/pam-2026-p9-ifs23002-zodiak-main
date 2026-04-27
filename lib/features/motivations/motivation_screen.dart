import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/motivation_provider.dart';

class MotivationScreen extends StatefulWidget {
  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MotivationProvider>().fetchMotivations());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<MotivationProvider>().fetchMotivations();
    }
  }

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, HH:mm").format(parsed);
    } catch (e) {
      return date;
    }
  }

  void showZodiacDialog() {
    final zodiacController = TextEditingController();
    final totalController = TextEditingController(text: "1");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Consumer<MotivationProvider>(
        builder: (context, provider, _) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
          ),
          title: const Text("Ramal Nasib Bintang", 
            style: TextStyle(color: Color(0xFFD4AF37), letterSpacing: 2)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: zodiacController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Nama Zodiak (ex: Leo)"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: totalController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Jumlah Ramalan (Max 10)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: provider.isGenerating ? null : () => Navigator.pop(dialogContext),
              child: const Text("Batal", style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: provider.isGenerating ? null : () async {
                final name = zodiacController.text.trim();
                final total = int.tryParse(totalController.text) ?? 1;
                if (name.isNotEmpty && total > 0 && total <= 10) {
                  await provider.generate(name, total);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text("Baca Nasib"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MotivationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("ZODIAC REVELATIONS", 
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, letterSpacing: 3)),
        backgroundColor: const Color(0xFF1E1E1E),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showZodiacDialog,
        backgroundColor: const Color(0xFF8B0000),
        child: const Icon(Icons.Bedtime, color: Color(0xFFD4AF37)),
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 16, bottom: 100),
            itemCount: provider.motivations.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < provider.motivations.length) {
                final item = provider.motivations[index];
                return _buildTarotCard(item, index + 1);
              }
              return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)));
            },
          ),
          if (provider.isGenerating)
            Container(
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF8B0000)),
                    SizedBox(height: 20),
                    Text("Menghubungkan ke rasi bintang...", 
                      style: TextStyle(color: Color(0xFFD4AF37), fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTarotCard(dynamic item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.6), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF8B0000),
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.star, color: Color(0xFFD4AF37), size: 18),
                Text("RAMALAN #$index", 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const Icon(Icons.star, color: Color(0xFFD4AF37), size: 18),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(item.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6, fontStyle: FontStyle.italic)),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFF3A3A3A)),
                Text(formatDate(item.createdAt), 
                  style: const TextStyle(color: Colors.white24, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}