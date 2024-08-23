import 'package:diplom/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/user_events.dart';
import 'package:diplom/models/chat_room_model.dart';
import 'package:diplom/screens/chat.dart';
import 'package:diplom/states/user_state.dart';
import 'package:intl/intl.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({super.key});

  @override
  State<ChatRooms> createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  List<ChatRoom> rooms = [];
  late User user;
  bool hasMore = true;
  @override
  void initState() {
    super.initState();
    user = context.read<UserBloc>().state.user!;
    context.read<UserBloc>().add(GetUserChatRooms(user.id));
    rooms = context.read<UserBloc>().state.chatRooms;
  }

  Future<void> refresh() async {
    context.read<UserBloc>().add(GetUserChatRooms(user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Таны чатууд',
          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: ((context, state) {
          return RefreshIndicator(
            onRefresh: refresh,
            child: Column(children: [
              const SizedBox(height: 10),
              state.chatRooms.length == 0
                  ? const Center(child: Text('Одоогоор чат байхгүй байна'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                      itemCount: state.chatRooms.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (state.chatRooms.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatRoom: state.chatRooms[index],
                                user: state.user!,
                              ),
                            ),
                          ),
                          child: Card(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.grey.shade100,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                    leading: Container(
                                      decoration: const BoxDecoration(),
                                      height: 40,
                                      width: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: state.chatRooms[index].users[0].image != null
                                            ? Image.network(
                                                state.chatRooms[index].users[0].image!,
                                              )
                                            : Image.asset(
                                                'assets/Images/person.png',
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    title: Text(
                                      state.user?.id == state.chatRooms[index].users[0].id
                                          ? state.chatRooms[index].users[1].name!
                                          : state.chatRooms[index].users[0].name!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    subtitle: state.chatRooms[index].messages.length == 0
                                        ? SizedBox()
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text(
                                                  state.chatRooms[index].messages[0].message!,
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  DateFormat('MMMM dd HH:mm')
                                                      .format(DateTime.parse(state
                                                          .chatRooms[index].messages[0].createdAt!))
                                                      .replaceAll('-', '.'),
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ]),
                                    trailing: const SizedBox(
                                      width: 10,
                                    ))
                              ],
                            ),
                          ),
                        );
                      }),
            ]),
          );
        }),
      ),
    );
  }
}
