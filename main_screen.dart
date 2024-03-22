
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _posts = [];
  bool _isLoading = false;

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> postsJson = jsonDecode(response.body);
      setState(() {
        _posts = postsJson;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text('Flutter API'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return ListTile(
                  title: Text(post['title']),
                  subtitle: Text(post['body']),
                );
              },
            ),
    );
  }
}


// Add Post class
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

class Album {
  final int userId;
  final int id;
  final String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = false;

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> postsJson = jsonDecode(response.body);
      setState(() {
        _posts = postsJson.map((json) => Post.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

@override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MultiScreen App'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return ListTile(
                  title: Text(post.title),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/post_detail',
                      arguments: {'post': post},
                    );
                  },
                );
              },
            ),
    );
  }
}

// Update AlbumsScreen to avoid conflicts
class AlbumsOtherNameScreen extends StatefulWidget {
  @override
  AlbumsOtherNameScreenState createState() => AlbumsOtherNameScreenState();
}

class AlbumsOtherNameScreenState extends State<AlbumsOtherNameScreen> {
  List<dynamic> _albums = [];
  bool _isLoading = false;

  Future<void> _fetchAlbums() async {
    // Implement fetchAlbums
  }

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Implement AlbumsOtherNameScreen
    );
  }
}

// Update PostDetailScreen
class PostDetailScreen extends StatelessWidget {
  final Post _post;

  const PostDetailScreen({Key? key, required Post post})
      : _post = post,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Text('Detalhes do Post (${_post.id})'),
      ),
      body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_post.title, style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text(_post.body, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// Add classes for Comments and Todos
class Comment {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Comment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}

class Todo {
  final int userId;
  final int id;
  final String title;
  bool completed;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

// Main app
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = "MultiScreen App";

    return MaterialApp(
      title: appTitle,
      //title: 'Hello Word',
      initialRoute: '/',
      home: MainScreen(),
      routes: {
        '/': (context) => MainScreen(),
        '/albums': (context) => AlbumsOtherNameScreen(),
        '/comments': (context) => CommentsScreen(),
        '/todos': (context) => TodosScreen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MultiScreen App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              child: Text('Posts'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PostsScreen())),
            ),
            ElevatedButton(
              child: Text('Albums'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumsScreen())),
            ),
            ElevatedButton(
              child: Text('Comments'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsScreen())),
            ),
            ElevatedButton(
              child: Text('Todos'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TodosScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

class AlbumsScreen extends StatefulWidget {
  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  List<Album> _albums = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  Future<void> _fetchAlbums() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

    if (response.statusCode == 200) {
      final List<dynamic> albumsJson = jsonDecode(response.body);
      setState(() {
        _albums = albumsJson.map((json) => Album.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load albums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _albums.length,
              itemBuilder: (context, index) {
                final album = _albums[index];
                return ListTile(
                  title: Text(album.title),
                  subtitle: Text('User ID: ${album.userId}'),
                  onTap: () {
                    // Ação ao tocar no álbum, pode abrir uma tela de detalhes do álbum ou algo similar
                  },
                );
              },
            ),
    );
  }
}

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<Comment> _comments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

    if (response.statusCode == 200) {
      final List<dynamic> commentsJson = jsonDecode(response.body);
      setState(() {
        _comments = commentsJson.map((json) => Comment.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Card(
                  child: ListTile(
                    title: Text(comment.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.email),
                        SizedBox(height: 10),
                        Text(comment.body),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class TodosScreen extends StatefulWidget {
  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  List<Todo> _todos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200) {
      final List<dynamic> todosJson = jsonDecode(response.body);
      setState(() {
        _todos = todosJson.map((json) => Todo.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? value) {
                      setState(() {
                        todo.completed = value!;
                      });
                    },
                  ),
                  title: Text(todo.title, style: TextStyle(decoration: todo.completed ? TextDecoration.lineThrough : null)),
                  onTap: () {
                    // Ação opcional ao tocar na tarefa
                  },
                );
              },
            ),
    );
  }
}
