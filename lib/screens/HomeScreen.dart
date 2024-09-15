import 'package:app_humor/data/dados_humor.dart';
import 'package:app_humor/model/humor.dart';
import 'package:app_humor/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Humor> _humores = dados_Humor;

  void _refreshHumores() {
    setState(() {
      _humores = List.from(dados_Humor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(),
      appBar: AppBar(
        title: Text('Diário do humor'),
        backgroundColor: Colors.blue[50],
      ),
      body: ListView.builder(
        itemCount: _humores.length,
        itemBuilder: (context, index) {
          final humor = _humores[index];
          return ListTile(
            title: Text(humor.emocao),
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
      MaterialPageRoute(builder: (context) => Registerscreen()),
    );

    if (result == true) {
      // Se o humor foi adicionado, atualize a lista
      _refreshHumores();
    }
  }
}
