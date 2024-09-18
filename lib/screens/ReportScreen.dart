import 'package:app_humor/data/provider.dart';
import 'package:app_humor/model/humor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:pie_chart/pie_chart.dart';

class Reportscreen extends ConsumerStatefulWidget {
  const Reportscreen({super.key});

  @override
  ConsumerState<Reportscreen> createState() => _ReportscreenState();
}

class _ReportscreenState extends ConsumerState<Reportscreen> {
  
  @override
  Widget build(BuildContext context) {
    //Obtenha a lista de humores do provider
    final humores = ref.watch(humorProvider);

    final Map<String, int> emocaoCount = {};
    for (var humor in humores) {
      emocaoCount[humor.emocao] = (emocaoCount[humor.emocao] ?? 0) + 1;
    }

    final sections = emocaoCount.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.value}',
        color: _getColorForEmotion(entry.key),
        radius: 50,
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Relatório de Humor',style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFFB71C1C),
      ),
      body:  emocaoCount.length == 0 ? Center(child: Text('Nenhuma emocão cadastrada')) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: sections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: emocaoCount.entries.map((entry) {
                return Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: _getColorForEmotion(entry.key),
                    ),
                    SizedBox(width: 10),
                    Text('${entry.key}: ${entry.value}'),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForEmotion(String emocao) {
    switch (emocao) {
      case 'Feliz':
        return Colors.yellow;
      case 'Pensativo':
        return Colors.grey;
      case 'Triste':
        return Colors.blue;
      case 'Raiva':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  // Função para calcular o número de ocorrências de cada tipo de humor
  Map<String, int> _calculateHumorCounts(List<Humor> humores) {
    final Map<String, int> counts = {};

    for (var humor in humores) {
      if (counts.containsKey(humor.emocao)) {
        counts[humor.emocao] = counts[humor.emocao]! + 1;
      } else {
        counts[humor.emocao] = 1;
      }
    }

    return counts;
  }

  // Função para formatar a data
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
