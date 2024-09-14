import 'package:app_humor/screens/HomeScreen.dart';
import 'package:app_humor/screens/ReportScreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selecionarIndex = 0;

  // Lista de telas que serão chamadas ao selecionar o item no BottomNavigationBar
  static List<Widget> _widgetOptions = <Widget>[
    Homescreen(),
    Reportscreen(),
  ];
  //metodo que muda o indice quando um botão for clicado
  void onitemSelected(int index) {
    setState(() {
      selecionarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _widgetOptions.elementAt(selecionarIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph_outlined, size: 35,), label: ''),
        ],
        currentIndex: selecionarIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        onTap: onitemSelected,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.blue[900],
       
      ),
    );
  }
}
