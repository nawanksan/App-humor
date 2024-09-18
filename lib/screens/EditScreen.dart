import 'package:app_humor/data/provider.dart';
import 'package:app_humor/model/humor.dart';
import 'package:app_humor/screens/MainScreeen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Editscreen extends ConsumerStatefulWidget {
  final Humor humor;
  Editscreen({Key? key, required this.humor}) : super(key: key);

  @override
  ConsumerState<Editscreen> createState() => _EditscreenState();
}

class _EditscreenState extends ConsumerState<Editscreen> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();

  DateTime? _selectedDate;
  String formattedDate = '';
  String? _selectedEmoji;
  String _emojiDescription = '';
  // String _descricao = '';
  DateTime _data = DateTime.now();

  final Map<String, String> _emojiDescriptions = {
    '😀': 'Feliz',
    '😪': 'pensativo',
    '😔': 'Triste',
    '😠': 'Raiva'
  };

  @override
  void initState() {
    super.initState();
    _initializeDateFormatting();
    _loadHumorData(); // Carrega os dados do humor que está sendo editado
  }

  // Inicializa a formatação de data para 'pt_BR'
  Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting('pt_BR', null);
    setState(() {
      formattedDate =
          getFormattedDate(); // Atualiza a data formatada depois da inicialização
    });
  }

  String getFormattedDate() {
    DateTime now = DateTime.now();
    return DateFormat('EEE d MMM', 'pt_BR')
        .format(now); // 'EEE' para dia da semana, 'd' para dia, 'MMM' para mês
  }

  void _loadHumorData() {
    // Carrega os dados do humor existente para editar
    _selectedDate = widget.humor.data;
    formattedDate = DateFormat('EEE d MMM', 'pt_BR').format(_selectedDate!);
    _selectedEmoji = widget.humor.icon;
    _emojiDescription = widget.humor.emocao;
    _descricaoController.text = widget.humor.descricao;
    _data = widget.humor.data;
  }

  //criando o calendario
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
      // locale: const Locale('pt', 'BR'),
    );

    //atualizando as data selecionada e mostrar a data selecionada
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        formattedDate = DateFormat('EEE d MMM', 'pt_BR').format(_selectedDate!);
        _data = pickedDate;
      });
    }
  }

  //selecionando o emoji
  void _selectEmoji(String emoji) {
    setState(() {
      _selectedEmoji = emoji;
      _emojiDescription = _emojiDescriptions[emoji] ?? '';
    });
  }

  //verificando o validator e adionando o novo humor
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      //atualiar o humor existente
      final updateHumor = Humor(
        id: widget.humor.id, // Mantém o mesmo ID,
        emocao: _emojiDescription,
        descricao: _descricaoController.text,
        data: _data,
        icon: _selectedEmoji!,
      );
      print('feito o update');
      ref.read(humorProvider.notifier).updateHumor(updateHumor);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MainScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Editar Humor'),
        backgroundColor: Colors.red[800],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today_rounded),
                                Text(
                                  "$formattedDate",
                                  style: TextStyle(color: Colors.black),
                                ),
                                IconButton(
                                  onPressed: () => _selectDate(context),
                                  icon: Icon(Icons.arrow_drop_down),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildEmojiButton('😀'),
                                _buildEmojiButton('😪'),
                                _buildEmojiButton('😔'),
                                _buildEmojiButton('😠'),
                                // Adicione mais emojis conforme necessário
                              ],
                            ),
                            if (_selectedEmoji != null)
                              Column(
                                children: [
                                  Text(
                                    'Emoji selecionado: $_selectedEmoji',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Descrição: $_emojiDescription',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              // initialValue: _descricao,
                              controller: _descricaoController,
                              cursorColor: Colors.blue,
                              decoration: InputDecoration(
                                hintText: 'Descreva seu dia',
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade50)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue.shade100)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira uma descrição.';
                                }
                                if (_selectedEmoji == null) {
                                  return 'Por favor, escolha um emoji acima antes de cadastrar.';
                                }
                                return null;
                              },
                              // onSaved: (value) {
                              //   _descricao = value!;
                              // },
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            TextButton(
                                onPressed: () => _submitForm(),
                                child: Text(
                                  'Salvar',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String emoji) {
    return IconButton(
      icon: Text(
        emoji,
        style: TextStyle(
          fontSize: 40,
        ),
      ),
      onPressed: () => _selectEmoji(emoji),
    );
  }
}
