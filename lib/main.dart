import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatResponse = '';

  Future<String> getChatResponse(String query) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'), // Replace with the ChatGPT API endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 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', // Replace with your OpenAI API key
      },
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['response'];
      return reply;
    } else {
      throw Exception('Failed to get chat response');
    }
  }

  void sendMessage(String message) async {
    setState(() {
      chatResponse = 'Loading...';
    });

    try {
      String response = await getChatResponse(message);
      setState(() {
        chatResponse = response;
      });
    } catch (e) {
      setState(() {
        chatResponse = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: 1,
              itemBuilder: (context, index) {
                return Text(chatResponse);
              },
            ),
          ),
          TextField(
            onSubmitted: sendMessage,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              contentPadding: EdgeInsets.all(16.0),
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => sendMessage(''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

