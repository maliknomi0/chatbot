// This is a simple Flutter app to initialize a chatbot using the Gemini library.
// Created by Malik Noman Tairq
// GitHub: https://github.com/maliknomi0
// LinkedIn: https://linkedin.com/in/maliknomi0
// Instagram: Malik.Nomi000
// Twitter: malik_nomi0
// WhatsApp: https://Wa.me/+923700204207

import 'package:chatbot/chatbot_page.dart';
import 'package:chatbot/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: Config.chatBotKEY); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quisitve',
      themeMode: ThemeMode.system,
      home: ChatbotPage(), 
    );
  }
}
