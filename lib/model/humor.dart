// import 'package:flutter_riverpod/flutter_riverpod.dart';

class Humor {
  final String id;
  final String emocao;
  final String descricao;
  final DateTime data;
  final String icon;

  const Humor({
    required this.id,
    required this.emocao,
    required this.descricao,
    required this.data,
    required this.icon
  });
}

// class HumorNotifier extends StateNotifier<List<Humor>> {
//   HumorNotifier() : super([]);

//   void addHumor(Humor humor) {
//     state = [...state, humor];
//   }
// }

// // Provider que expõe o HumorNotifier
// final humorProvider = StateNotifierProvider<HumorNotifier, List<Humor>>((ref) {
//   return HumorNotifier();
// });