import 'package:app_humor/data/provider.dart';
import 'package:app_humor/screens/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {

  @override
  void initState() {
    super.initState();
    verificarCadastroHumorDia();
  }

  Future<void> limparTodoSharedPreferences() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    // print("SharedPreferences limpo com sucesso!");
    // // _refreshHumores();
    ref.read(humorProvider.notifier).clearAllHumores();
  }

  @override
  Widget build(BuildContext context) {
    final humores = ref.watch(humorProvider);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_sharp),
                  Text('Perfil'),
                ],
              ),
            ),
            Center(child: Text('KAWAN')),
            Image.asset(
              'assets/kawan.png',
              width: 200,
              height: 250,
            ),
            Center(child: Text('HERISSON')),
            Image.asset(
              'assets/herisson.jpg',
              width: 200,
              height: 250,
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Diário do humor'),
        backgroundColor: Colors.blue[50],
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: const Text(
                      'Aviso',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    content: const Text(
                      'Deseja apagar todos os humores cadastrados?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17), // Centraliza o texto
                    ),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        onPressed: () {
                          // Ação principal

                          Navigator.of(context).pop();
                        },
                        // isDefaultAction: false,
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ), // Destaca o botão principal
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          // Ação principal
                          limparTodoSharedPreferences();
                          Navigator.of(context).pop();
                        },
                        // isDefaultAction: false,
                        child: const Text(
                          'OK',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ), // Destaca o botão principal
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: humores.length,
        itemBuilder: (context, index) {
          final humor = humores[index];
          return ListTile(
            title: Text(
              humor.icon + " " + humor.emocao,
              style: const TextStyle(fontSize: 25),
            ),
            subtitle: Text(humor.descricao),

            trailing:
                Text(formatDate(humor.data)), // Formata a data para exibição
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Registerscreen()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.blue[50],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // void _navigateToAddHumor() async {
  //   // Navega para a tela de adicionar humor e aguarda o retorno
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const Registerscreen()),
  //   );

  //   // if (result == true) {
  //   //   // Se o humor foi adicionado, atualize a lista
  //   //   _refreshHumores();
  //   // }
  // }

  // Verifica se o humor foi cadastrado hoje
  Future<void> verificarCadastroHumorDia() async {
    final prefs = await SharedPreferences.getInstance();
    final hoje = DateTime.now();
    final ultimoCadastro = prefs.getString('ultimo_cadastro') ?? '';

    // Se não cadastrou o humor hoje, mostre um alerta
    if (ultimoCadastro != '${hoje.day}-${hoje.month}-${hoje.year}') {
      mostrarAlertaCadastrarHumor();
    }
  }

  void mostrarAlertaCadastrarHumor() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text(
            'Lembrete Diário',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          content: const Text(
            'Você ainda não cadastrou seu humor hoje! Não se esqueça!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17), // Centraliza o texto
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                // Ação principal
                Navigator.of(context).pop();
              },
              // isDefaultAction: false,
              child: const Text(
                'OK',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ), // Destaca o botão principal
            ),
          ],
        );
      },
    );
  }
}
