import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/motivation_provider.dart';
import '../../core/theme/theme_notifier.dart';

class MotivationScreen extends StatefulWidget {
  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mengambil data awal dari BE
    Future.microtask(() => context.read<MotivationProvider>().fetchMotivations());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        context.read<MotivationProvider>().fetchMotivations();
      }
    });
  }

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, HH:mm").format(parsed);
    } catch (e) {
      return date;
    }
  }

  void showGenerateDialog() {
    final themeController = TextEditingController();
    final totalController = TextEditingController(text: "1");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<MotivationProvider>(
          builder: (context, provider, _) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5), // Border Emas
              ),
              title: const Text(
                "Meracik Ramuan Pathway",
                style: TextStyle(color: Color(0xFFD4AF37), fontFamily: 'Serif'),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: themeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Domain Kekuatan (Tema)",
                      labelStyle: TextStyle(color: Colors.white60),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: totalController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Jumlah (Max 10)", // Sesuai limit BE
                      labelStyle: TextStyle(color: Colors.white60),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: provider.isGenerating ? null : () => Navigator.pop(dialogContext),
                  child: const Text("Batal", style: TextStyle(color: Colors.white54)),
                ),
                ElevatedButton(
                  onPressed: provider.isGenerating 
                    ? null 
                    : () async {
                        final theme = themeController.text.trim();
                        final total = int.tryParse(totalController.text) ?? 1;

                        if (theme.isNotEmpty && total > 0 && total <= 10) {
                          await provider.generate(theme, total);
                          Navigator.pop(dialogContext);
                        }
                      },
                  child: const Text("Transcend"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MotivationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Hitam Pekat
      appBar: AppBar(
        title: const Text(
          "TOME OF SECRETS",
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFD4AF37)),
            onPressed: () {
              provider.motivations.clear();
              provider.page = 1;
              provider.hasMore = true;
              provider.fetchMotivations();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showGenerateDialog,
        backgroundColor: const Color(0xFF8B0000), // Crimson
        child: const Icon(Icons.auto_stories, color: Colors.white),
      ),
      body: provider.motivations.isEmpty && provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: provider.motivations.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < provider.motivations.length) {
                  final item = provider.motivations[index];
                  return _buildPathwayCard(item, index + 1);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator(color: Color(0xFF8B0000))),
                  );
                }
              },
            ),
    );
  }

  Widget _buildPathwayCard(dynamic item, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Stack(
        children: [
          // Aksen Ornamen Pojok
          const Positioned(
            top: 5, right: 5,
            child: Icon(Icons.all_out, color: Color(0xFF3A3A3A), size: 40),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PATHWAY #$index",
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      formatDate(item.createdAt), // Data dari BE
                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF3A3A3A), thickness: 1, height: 25),
                Text(
                  item.text,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}