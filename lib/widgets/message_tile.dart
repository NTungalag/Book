import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final String createdAt;

  final bool sentByMe;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.createdAt})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        show = !show;
      }),
      child: Container(
        padding: EdgeInsets.only(
            top: 4, bottom: 4, left: widget.sentByMe ? 0 : 24, right: widget.sentByMe ? 24 : 0),
        alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
            crossAxisAlignment: widget.sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: double.infinity / 4 * 3),
                margin: widget.sentByMe
                    ? const EdgeInsets.only(left: 30)
                    : const EdgeInsets.only(right: 30),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: widget.sentByMe
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                    color: widget.sentByMe
                        ? const Color.fromARGB(255, 153, 136, 205)
                        : Colors.grey.shade600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sender,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(widget.message,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 13, color: Colors.white))
                  ],
                ),
              ),
              const SizedBox(height: 3),
              show
                  ? Text(
                      widget.createdAt,
                      textAlign: widget.sentByMe ? TextAlign.right : TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    )
                  : SizedBox(),
            ]),
      ),
    );
  }
}
