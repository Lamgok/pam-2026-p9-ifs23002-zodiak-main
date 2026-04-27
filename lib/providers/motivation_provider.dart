import 'package:flutter/material.dart';
import '../data/models/motivation_model.dart';
import '../data/services/motivation_service.dart';

class MotivationProvider extends ChangeNotifier {
  List<Motivation> motivations = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool isGenerating = false;
  String? error;

  Future<void> fetchMotivations() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await MotivationService.getMotivations(page);
      List data = result["data"];

      if (data.isEmpty) {
        hasMore = false;
      } else {
        motivations.addAll(data.map((e) => Motivation.fromJson(e)).toList());
        page++;
      }
    } catch (e) {
      error = "Gagal memanggil bintang-bintang: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generate(String zodiacName, int total) async {
    isGenerating = true;
    error = null;
    notifyListeners();

    try {
      // Mengirim nama zodiak ke parameter 'theme' di BE
      await MotivationService.generateMotivation(zodiacName, total);

      motivations.clear();
      page = 1;
      hasMore = true;

      await fetchMotivations();
    } catch (e) {
      error = "Ritual ramalan gagal: $e";
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }
}