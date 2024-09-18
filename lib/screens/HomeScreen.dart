import 'package:app_humor/data/provider.dart';
import 'package:app_humor/model/humor.dart';
import 'package:app_humor/screens/EditScreen.dart';
import 'package:app_humor/screens/MainScreeen.dart';
import 'package:app_humor/screens/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  final hoje = DateTime.now();
  Humor? _selectedHumor;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verificarCadastroHumorDia2();
    });
  }

  // Inicializa as notificações
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Verifica se o humor do dia já foi cadastrado
  void verificarCadastroHumorDia2() async {
    await ref.read(humorProvider.notifier).loadHumores();
    verificarCadastroHumorDia(hoje);
  }

  @override
  Widget build(BuildContext context) {
    final humores = ref.watch(humorProvider);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: _buildHumorList(humores),
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

  // Drawer da tela principal
  Drawer _buildDrawer() {
    return Drawer(
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
                Icon(Icons.people_sharp, size: 50),
                Text(
                  'Perfil',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
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
    );
  }

  // AppBar da tela principal
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Diário do humor', style: TextStyle(color: Colors.white)),
      backgroundColor: Color(0xFFB71C1C),
      actions: [
        if (_selectedHumor != null)
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: Colors.white),
            onPressed: _showDeleteConfirmation,
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
            icon: Icon(Icons.edit, color: Colors.white),
          ),
      ],
    );
  }

  // Lista de humores
  Widget _buildHumorList(List<Humor> humores) {
    return ListView.builder(
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
              _selectedHumor == humor ? _selectedHumor = null : _selectedHumor = humor;
            });
          },
        );
      },
    );
  }

  // Função para formatar a data
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Verifica se há um humor cadastrado hoje e exibe notificação se não houver
  Future<void> verificarCadastroHumorDia(DateTime data) async {
    final humores = ref.read(humorProvider);

    final humorDoDia = humores.where((humor) =>
        humor.data.day == data.day &&
        humor.data.month == data.month &&
        humor.data.year == data.year).toList();

    if (humorDoDia.isEmpty) {
      _showNotification();
    }
  }

  // Função para exibir notificação
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Lembrete de humor para hoje',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Registrar Humor',
      'Você ainda não registrou seu humor hoje!',
      notificationDetails,
    );
  }

  // Mostra o diálogo de confirmação de exclusão
  void _showDeleteConfirmation() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Aviso', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          content: const Text('Deseja apagar o humor cadastrado?', textAlign: TextAlign.center),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar', style: TextStyle(color: Colors.blue, fontSize: 20)),
            ),
            CupertinoDialogAction(
              onPressed: () {
                _removerHumor(_selectedHumor!);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ));
              },
              child: const Text('OK', style: TextStyle(color: Colors.blue, fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  // Função para remover humor
  void _removerHumor(Humor humor) async {
    final provider = ref.read(humorProvider.notifier);
    provider.removeHumor(humor);
  }
}
