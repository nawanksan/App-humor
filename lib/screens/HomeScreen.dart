import 'package:app_humor/data/dados_humor.dart';
import 'package:app_humor/model/humor.dart';
import 'package:app_humor/screens/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Humor> _humores = dados_Humor;

  @override
  void initState() {
    super.initState();
    _refreshHumores();
  }

  void _refreshHumores() {
    setState(() {
      _humores = List.from(dados_Humor);
      verificarCadastroHumor();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Text('Perfis'),
                ],
              ),
            ),
            Center(child: Text('KAWAN')),
            Image.asset(
              'assets/kawan.png',
              width: 150,
              height: 150,
            ),
            Center(child: Text('HERISSON')),
            Image.asset(
              'assets/herisson.jpg',
              width: 150,
              height: 150,
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Diário do humor'),
        backgroundColor: Colors.blue[50],
      ),
      body: ListView.builder(
        itemCount: _humores.length,
        itemBuilder: (context, index) {
          final humor = _humores[index];
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
        onPressed: () => _navigateToAddHumor(),
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

  void _navigateToAddHumor() async {
    // Navega para a tela de adicionar humor e aguarda o retorno
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Registerscreen()),
    );

    if (result == true) {
      // Se o humor foi adicionado, atualize a lista
      _refreshHumores();
    }
  }

  // Verifica se o humor foi cadastrado hoje
  Future<void> verificarCadastroHumor() async {
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
