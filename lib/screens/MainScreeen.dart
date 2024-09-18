import 'package:app_humor/screens/HomeScreen.dart';
import 'package:app_humor/screens/ReportScreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  // Lista de telas que serão chamadas ao selecionar o item no BottomNavigationBar
  List<Widget> _widgetOptions = <Widget>[
    const Homescreen(),
    const Reportscreen(),
  ];
  //metodo que muda o indice quando um botão for clicado
  void onitemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph_outlined, size: 35,), label: ''),
        ],
        
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[700],
        onTap: onitemSelected,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFFB71C1C),
        type: BottomNavigationBarType.fixed,
       
      ),
    );
  }
}
