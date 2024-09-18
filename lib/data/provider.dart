
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_humor/model/humor.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//gerencia o estado da lista de humor
final humorProvider = StateNotifierProvider<HumorNotifier, List<Humor>>((ref) {
  return HumorNotifier(ref);
});

//permitir acessar outros providers necessário
class HumorNotifier extends StateNotifier<List<Humor>> {
  final Ref read;

  //_loadHumores() é chamada no construtor para carregar os humores armazenados no SharedPreferences ao iniciar.
  HumorNotifier(this.read) : super([]) {
    _loadHumores();
  }

  //Ele usa o operador spread (...) para criar uma nova lista que inclui o humor recém-adicionado
  void addHumor(Humor humor) async {
    state = [...state, humor];
    await _saveHumores();
  }
  
  //Essa função limpa toda a lista de humores e chama o shared_preferences para atualizar essa lista
  void removeAllHumores() async {
    state = [];
    await _saveHumores();
  }

  //limpa todos os humores salvao no shared_preferences
  Future<void> clearAllHumores() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('humores');
    // Notifica o estado para atualizar a tela
  }

  //remover um humor especificada
  void removeHumor(Humor humor) async {
    state = state.where((h) => h.id != humor.id).toList();// Remove o humor da lista
    await _saveHumores(); // Atualiza os dados armazenados no SharedPreferences
  }

  //carrega os humores armazenados no SharedPreferences ao iniciar o aplicativo e cria uma nova instancia 
  //de humor ao chamar o fromJson
  Future<void> _loadHumores() async {
    final prefs = await SharedPreferences.getInstance();
    final humorListJson = prefs.getStringList('humores') ?? [];

    state = humorListJson.map((jsonString) {
      return Humor.fromJson(jsonDecode(jsonString));
    }).toList();
  }

   Future<void> loadHumores() async {
    await _loadHumores();
  }
  
  //Essa função salva a lista atual de humores no SharedPreferences
  Future<void> _saveHumores() async {
    final prefs = await SharedPreferences.getInstance();
    final humorListJson = state.map((humor) => jsonEncode(humor.toJson())).toList();
    await prefs.setStringList('humores', humorListJson);
  }

  // Função para atualizar um humor
  void updateHumor(Humor updatedHumor) async{
    state = [
      for (final humor in state)
        if (humor.id == updatedHumor.id) updatedHumor else humor,
    ];
    // Salva a lista atualizada no SharedPreferences
     await _saveHumores();
  }

}
