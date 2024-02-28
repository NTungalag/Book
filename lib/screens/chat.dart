import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:diplom/models/chat_room_model.dart';
import 'package:diplom/models/message_model.dart';
import 'package:diplom/models/user_model.dart';
import 'package:diplom/widgets/message_tile.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;
  final User user;

  const ChatScreen({super.key, required this.chatRoom, required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  late List<Message> _messages = [];
  late User sender;
  late bool toSend;
  ScrollController co = ScrollController();

  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    toSend = false;
    sender = widget.user.id == widget.chatRoom.users[0].id
        ? widget.chatRoom.users[1]
        : widget.chatRoom.users[0];
    socket = IO.io('http://localhost:8000', <String, dynamic>{
      'transports': ['websocket'],
      // 'autoConnect': false,
    });

    socket.on('connect', (_) {
      // String roomId = '${widget.chatRoom.id}_${widget.user.id}_${sender.id}';
      socket.emit('joinRoom', {'roomId': widget.chatRoom.id});
      socket.emit('chatHistory', {'chatRoomId': widget.chatRoom.id});
    });

    socket.on('chatHistory', (data) {
      List<dynamic> messageDataList = List<dynamic>.from(data);
      List<Message> messageList = messageDataList.map((messageData) {
        return Message.fromMap(messageData);
      }).toList();

      setState(() {
        _messages = messageList.reversed.toList();
      });
      co.animateTo(co.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });

    socket.on('disconnect', (_) => socket.disconnected);

    socket.on('message', (data) {
      final message = Message.fromMap(data['message']);

      if (message.chatRoomId == widget.chatRoom.id) {
        setState(() {
          _messages.insert(0, message);
        });
        co.animateTo(
          co.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        // co.jumpTo(co.position.maxScrollExtent);
      }
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
    // String roomId = '${widget.chatRoom.id}_${widget.user.id}_${sender.id}';
    setState(() {
      toSend = false;
      _textController.clear();
    });
    socket.emit('message', {
      'messageText': String.fromCharCodes(Runes(text)),
      'senderUserId': widget.user.id,
      'chatRoomId': widget.chatRoom.id,
      'roomId': widget.chatRoom.id,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          widget.chatRoom.users[0].image != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(widget.chatRoom.users[0].image!),
                  radius: 15.0,
                )
              : CircleAvatar(
                  radius: 15.0,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/Images/person.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          const SizedBox(width: 10),
          Text(
            widget.user.id == widget.chatRoom.users[1].id
                ? widget.chatRoom.users[0].name!
                : widget.chatRoom.users[1].name!,
            style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ]),
        backgroundColor: Colors.white,
        // leadingWidth: 50,
        leading: IconButton(
          // alignment: Alignment.centerLeft,
          // padding: EdgeInsets.only(left: 16),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: co,
              itemBuilder: (BuildContext context, int i) {
                if (i == _messages.length) {
                  return Container(
                    height: 20,
                  );
                }
                return MessageTile(
                  message: _messages[i].message!,
                  sender: _messages[i].userId == widget.user.id ? widget.user.name! : sender.name!,
                  sentByMe: _messages[i].userId == widget.user.id,
                  createdAt: DateFormat('yy MMMM dd HH:mm')
                      .format(DateTime.parse(_messages[i].createdAt!))
                      .replaceAll('-', '.'),
                );
              },
              itemCount: _messages.length + 1,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    maxLines: 4,
                    minLines: 1,
                    maxLength: 160,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Мессеж бичих',
                    ),
                    onSubmitted: _sendMessage,
                    onChanged: (value) {
                      if (value.length == 0) {
                        setState(() {
                          toSend = false;
                        });
                      } else {
                        setState(() {
                          toSend = true;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      !toSend
                          ? const Color.fromARGB(255, 206, 206, 206)
                          : const Color.fromARGB(255, 153, 136, 205),
                    ),
                  ),
                  child: const Text('Илгээх'),
                  onPressed: () =>
                      _textController.text != '' ? _sendMessage(_textController.text) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
