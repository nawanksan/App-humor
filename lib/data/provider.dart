
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_humor/model/humor.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final humorProvider = StateNotifierProvider<HumorNotifier, List<Humor>>((ref) {
  return HumorNotifier(ref);
});

class HumorNotifier extends StateNotifier<List<Humor>> {
  final Ref read;

  HumorNotifier(this.read) : super([]) {
    _loadHumores();
  }

  void addHumor(Humor humor) async {
    state = [...state, humor];
    await _saveHumores();
  }

  void removeAllHumores() async {
    state = [];
    await _saveHumores();
  }

  Future<void> clearAllHumores() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('humores');
    // Notifica o estado para atualizar a tela
  }

  Future<void> _loadHumores() async {
    final prefs = await SharedPreferences.getInstance();
    final humorListJson = prefs.getStringList('humores') ?? [];

    state = humorListJson.map((jsonString) {
      return Humor.fromJson(jsonDecode(jsonString));
    }).toList();
  }

  Future<void> _saveHumores() async {
    final prefs = await SharedPreferences.getInstance();
    final humorListJson = state.map((humor) => jsonEncode(humor.toJson())).toList();
    await prefs.setStringList('humores', humorListJson);
  }
}
