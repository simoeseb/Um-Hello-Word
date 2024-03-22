import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _nicknameController = TextEditingController();
  bool _nicknameValid = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _decodeString(String text) {
    List<int> integers = base64Decode(text);
    String decodedString = String.fromCharCodes(integers);
    return decodedString;
  }

  String _encodeString(String text) {
    List<int> integers = text.codeUnits;
    String encodedString = base64Encode(integers);
    return encodedString;
  }

  void _validateNickname(String value) {
    setState(() {
      _nicknameValid = value.length >= 3 && value.length <= 20;
    });
  }

    Future<void> _saveNickname() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Aqui você deve obter o valor de PAT. Estamos usando um valor fictício para este exemplo.
  String pat = "PATExemplo";

  // Verifica se o apelido já foi salvo com algum PAT
  String? existingPat = prefs.getString(_nicknameController.text);

  if (existingPat != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Apelido já existe.')));
    return;
  }

  await prefs.setString(_nicknameController.text, pat);
  _nicknameController.clear();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuário salvo com sucesso.')));  
}

Future<List<String>> _getStoredNicknames() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  return keys.map((nickname) => prefs.getString(nickname)!).toList();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hello World')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nicknameController,
                onChanged: _validateNickname,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Apelido é obrigatório';
                  if (value.length < 3) return 'Apelido deve ter pelo menos 3 caracteres';
                  if (value.length > 20) return 'Apelido deve ter no máximo 20 caracteres';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Apelido',
                  hintText: 'Mínimo 3 e máximo 20 caracteres alfanuméricos',
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                ],
              ),
              FutureBuilder(
                future: _getStoredNicknames(),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                    title: Text(snapshot.data![index]),
                      );
                    },
                    ),
                  );
                  }

                  return CircularProgressIndicator();
              },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _nicknameValid ? _saveNickname : null,
                child: Text('Salvar'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _nicknameValid ? _saveNickname : null,
                child: Text('Salvar'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final post = await _fetchPost(1);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load post')));
                  }
                },
                child: Text('Postagens'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Post> _fetchPost(int postId) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,

  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(post.body),
      ),
    );
  }
}
