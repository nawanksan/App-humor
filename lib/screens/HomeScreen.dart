import 'package:app_humor/data/provider.dart';
import 'package:app_humor/model/humor.dart';
import 'package:app_humor/screens/EditScreen.dart';
import 'package:app_humor/screens/MainScreeen.dart';
import 'package:app_humor/screens/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  final hoje = DateTime.now();
  Humor? _selectedHumor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verificarCadastroHumorDia2();
    });
  }

  void verificarCadastroHumorDia2() async {
     // Aguarda o carregamento dos humores
    await ref.read(humorProvider.notifier).loadHumores();

  // Faz a verificação após os dados serem carregados
    verificarCadastroHumorDia(hoje);
  }

  // Future<void> limparTodoSharedPreferences() async {
  //   ref.read(humorProvider.notifier).clearAllHumores();
  // }

  @override
  Widget build(BuildContext context) {
    final humores = ref.watch(humorProvider);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: Drawer(
        backgroundColor: Colors.grey[300],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red[800],
                
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_sharp,size: 50,),
                  Text('Perfil',style: TextStyle(color: Colors.white, fontSize: 20),),
                ],
              ),
            ),
            Center(child: Text('KAWAN')),
            Image.asset(
              'assets/kawan.png',
              width: 200,
              height: 250,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Diário do humor',style: TextStyle(color: Colors.white),),
        
        backgroundColor: Color(0xFFB71C1C),
        actions: [
          if (_selectedHumor != null)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: Colors.white,),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text(
                        'Aviso',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      content: const Text(
                        'Deseja apagar o humor cadastrado?',
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
                            _removerHumor(_selectedHumor!);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ));
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
            ),
          if (_selectedHumor != null)
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Editscreen(humor: _selectedHumor!),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Colors.white))
        ],
      ),
      body: ListView.builder(
        itemCount: humores.length,
        itemBuilder: (context, index) {
          final humor = humores[index];
          return ListTile(
            leading: Radio<Humor>(
              value: humor,
              groupValue: _selectedHumor,
              onChanged: (Humor? value) {
                setState(() {
                  _selectedHumor = value;
                });
              },
            ),
            title: Text(
              humor.icon + " " + humor.emocao,
              style: const TextStyle(fontSize: 25),
            ),
            subtitle: Text(humor.descricao),
            trailing: Text(formatDate(humor.data)),
            onTap: () {
              setState(() {
                _selectedHumor == humor
                    ? _selectedHumor = null
                    : _selectedHumor =
                        humor; // Atualiza o humor selecionado ao clicar
              });
            },

            // Formata a data para exibição
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
          color: Colors.grey[300],
        ),
        backgroundColor: Colors.red[800],
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Verifica se o humor foi cadastrado hoje
  Future<void> verificarCadastroHumorDia(DateTime data) async {
    // Obtendo a lista de humores do humorProvider
    final humores = ref.read(humorProvider);

    final humorDoDia = humores.where((humor) =>
      humor.data.day == data.day &&
      humor.data.month == data.month &&
      humor.data.year == data.year,
    ).toList();
    

    // Se não encontrar nenhum humor com a data especificada, mostrar o alerta
    if (humorDoDia.isEmpty) {
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

  void _removerHumor(Humor humor) async {
    final provider = ref.read(humorProvider.notifier);
    provider.removeHumor(humor);
  }
}
