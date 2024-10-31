import 'dart:convert';
import 'dart:io';

import 'package:chatbot/chatbubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<ChatBubble> _messages = [];
  final List<Content> _conversationHistory = [];
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final List<String> _suggestedMessages = [
    'Tell me an interesting fact.',
    'Explain a concept you find fascinating.',
    'What is a scientific theory?',
    'Share a historical event.',
    'Explain a math problem.',
    'Describe a literary work.',
    'What is an important invention?',
    'Tell me about a significant discovery.',
    'Explain a programming concept.',
    'Describe a natural phenomenon.'
  ];

  bool _chatStarted = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await _storage.read(key: 'messages');
    final conversationHistory = await _storage.read(key: 'conversationHistory');

    if (messages != null && conversationHistory != null) {
      setState(() {
        _messages.addAll((jsonDecode(messages) as List)
            .map((message) => ChatBubble.fromJson(message))
            .toList());
        _conversationHistory.addAll((jsonDecode(conversationHistory) as List)
            .map((history) => Content.fromJson(history))
            .toList());
        _chatStarted = _messages.isNotEmpty;
      });
    }
  }

  Future<void> _saveMessages() async {
    await _storage.write(
        key: 'messages',
        value:
            jsonEncode(_messages.map((message) => message.toJson()).toList()));
    await _storage.write(
        key: 'conversationHistory',
        value: jsonEncode(
            _conversationHistory.map((history) => history.toJson()).toList()));
  }

  void _clearMessages() async {
    await _storage.delete(key: 'messages');
    await _storage.delete(key: 'conversationHistory');
    setState(() {
      _messages.clear();
      _conversationHistory.clear();
      _chatStarted = false;
    });
  }

  void _sendMessage(String text, {File? imageFile}) async {
    if (text.isEmpty && imageFile == null) return;

    setState(() {
      _chatStarted = true;
      _messages.add(
          ChatBubble(text: text, imageFile: imageFile, isUserMessage: true));
      _messages.add(const ChatBubble(
          text: 'Bot is typing...', isUserMessage: false, isTyping: true));
    });

    _controller.clear();
    _selectedImage = null;

    _conversationHistory.add(Content(parts: [Parts(text: text)], role: 'user'));
    await _saveMessages();

    final gemini = Gemini.instance;

    try {
      final response = imageFile == null
          ? await gemini.chat(_conversationHistory)
          : await gemini.textAndImage(
              text: text, images: [await imageFile.readAsBytes()]);

      if (response != null) {
        final botResponse = response.content?.parts?.last.text ?? 'No response';
        setState(() {
          _messages.removeWhere((msg) => msg.isTyping);
          _messages.add(ChatBubble(text: botResponse, isUserMessage: false));
        });

        _conversationHistory
            .add(Content(parts: [Parts(text: botResponse)], role: 'model'));
      }
    } catch (e) {
      setState(() {
        _messages.removeWhere((msg) => msg.isTyping);
        _messages.add(ChatBubble(text: 'Error: $e', isUserMessage: false));
      });
    }

    await _saveMessages();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _deselectImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _onSuggestedMessageTap(String message) {
    _sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _clearMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyChat()
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _messages[index],
                  ),
          ),
          if (!_chatStarted) _buildSuggestedMessages(),
          if (_selectedImage != null)
            _buildImageMessageInput()
          else
            _buildTextMessageInput(),
        ],
      ),
    );
  }

  Widget _buildEmptyChat() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 100),
          SizedBox(height: 20),
          Text('Start a conversation!', style: TextStyle(fontSize: 24)),
          SizedBox(height: 10),
          Text(
            'Ask me anything about your studies.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedMessages() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _suggestedMessages.map((message) {
            return GestureDetector(
              onTap: () => _onSuggestedMessageTap(message),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(message,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildImageMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.file(_selectedImage!, width: 150, height: 150),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Add a message',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text,
                      imageFile: _selectedImage)),
              IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _deselectImage,
                  color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => _pickImage(ImageSource.camera)),
          IconButton(
              icon: const Icon(Icons.photo),
              onPressed: () => _pickImage(ImageSource.gallery)),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Type your message',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _sendMessage(_controller.text)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
