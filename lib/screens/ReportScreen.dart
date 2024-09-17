import 'package:app_humor/data/provider.dart';
import 'package:app_humor/model/humor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class Reportscreen extends ConsumerStatefulWidget {
  const Reportscreen({super.key});

  @override
  ConsumerState<Reportscreen> createState() => _ReportscreenState();
}

class _ReportscreenState extends ConsumerState<Reportscreen> {
  @override
  Widget build(BuildContext context) {
    // Obtenha a lista de humores do provider
    final humores = ref.watch(humorProvider);

    final Map<String, int> emocaoCount = {};
    for (var humor in humores) {
      emocaoCount[humor.emocao] = (emocaoCount[humor.emocao] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Humor'),
        backgroundColor: Colors.blue[50],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          //   const Text(
          //     'Relatório de Humores (Gráfico de Barras)',
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //   ),
            const SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final emotion = emocaoCount.keys.elementAt(value.toInt());
                          return Text(
                            emotion,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    )
                  ),
                  barGroups: _buildBarGroups(emocaoCount),
                ),
              ),
            ),

            // Exiba as estatísticas ou um gráfico
            // ...humorCounts.entries.map((entry) => Text(
            //       '${entry.key}: ${entry.value}',
            //       // style: Theme.of(context).textTheme.bodyText1,
            //     )),
          ],
        ),
      ),
    );
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
  List<BarChartGroupData> _buildBarGroups(Map<String, int> emocaoCount) {
    return emocaoCount.entries
        .map((entry) {
          final index = emocaoCount.keys.toList().indexOf(entry.key);
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(), // Atualização aqui, de 'y' para 'toY'
                color: Colors.blue,
                width: 20,
              ),
            ],
          );
        })
        .toList();
  }

  // Função para formatar a data
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
