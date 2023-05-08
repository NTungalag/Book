import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://localhost:8000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.on('connect', (_) => print('connected'));
    socket.on('disconnect', (_) => print('disconnected'));
    socket.on('message', (data) {
      print(data);
      setState(() {
        _messages.add(data['text']);
      });
    });
    socket.connect();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    _textController.clear();
    socket.emit('message', {'text': text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket.IO Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
              itemCount: _messages.length,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(hintText: 'Enter a message'),
                    onSubmitted: _sendMessage,
                  ),
                ),
                ElevatedButton(
                  child: const Text('Send'),
                  onPressed: () => _sendMessage(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
