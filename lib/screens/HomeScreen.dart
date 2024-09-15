import 'package:app_humor/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int humores = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(),
      appBar: AppBar(
        title: Text('Diário do humor'),
        backgroundColor: Colors.blue[50],
      ),
      body: Container(
        child: Center(
          child: Text( humores == 0 ? 'Nenhum Registro' : 'Bem-vindo ao Diário de Humor!'),
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Registerscreen()));
        }, 
        child: Icon(Icons.add,color: Colors.black,),
        
        backgroundColor: Colors.blue[50],
        
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}