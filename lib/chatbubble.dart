
import 'dart:io';

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String? text;
  final File? imageFile;
  final bool isUserMessage;
  final bool isTyping;

  const ChatBubble({
    this.text,
    this.imageFile,
    required this.isUserMessage,
    this.isTyping = false,
    super.key,
  });

  factory ChatBubble.fromJson(Map<String, dynamic> json) {
    return ChatBubble(
      text: json['text'] as String?,
      isUserMessage: json['isUserMessage'] as bool,
      isTyping: json['isTyping'] as bool,
      imageFile: json['imageFile'] != null ? File(json['imageFile']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUserMessage': isUserMessage,
      'isTyping': isTyping,
      'imageFile': imageFile?.path,
    };
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: isUserMessage ? Colors.white : Colors.black87);

    return Row(
      mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUserMessage)
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.chat, color: Colors.white),
          ),
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: isUserMessage ? Theme.of(context).colorScheme.primary : Colors.grey[300],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isTyping) const Text('Typing...', style: TextStyle(fontStyle: FontStyle.italic)),
              if (imageFile != null) Image.file(imageFile!, width: 150, height: 150),
              if (text != null && !isTyping) Text(text!, style: textStyle),
            ],
          ),
        ),
        if (isUserMessage)
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.person, color: Colors.white),
          ),
      ],
    );
  }
}
