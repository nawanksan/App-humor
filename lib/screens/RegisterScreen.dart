import 'package:app_humor/data/dados_humor.dart';
import 'package:app_humor/model/humor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String formattedDate = '';
  String? _selectedEmoji;
  String _emojiDescription = '';
  String _descricao = '';
  DateTime _data = DateTime.now();
  String _id = DateTime.now().toIso8601String();

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
      // locale: const Locale('pt', 'BR'),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        formattedDate = DateFormat('EEE d MMM', 'pt_BR').format(_selectedDate!);
        _data = pickedDate;
      });
    }
  }

  void _selectEmoji(String emoji) {
    setState(() {
      _selectedEmoji = emoji;
      _emojiDescription = _emojiDescriptions[emoji] ?? '';
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      addHumor(_id, _emojiDescription, _descricao, _data);
      Navigator.pop(context, true);
          // Voltar para a tela anterior após salvar
    }
  }

  void addHumor(String id, String emocao, String descricao, DateTime data) {
    final newHumor = Humor(
      id: id,
      emocao: emocao,
      descricao: descricao,
      data: data,
    );
    dados_Humor.add(newHumor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'Como vc está?',
                        style: TextStyle(fontSize: 33),
                      ),
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
                              decoration:
                                  InputDecoration(hintText: 'Descreva seu dia'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira uma descrição.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _descricao = value!;
                              },
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            TextButton(
                                onPressed: () => _submitForm(),
                                child: Text(
                                  'Salvar',
                                  style: TextStyle(fontSize: 25),
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
