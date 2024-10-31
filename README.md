# Chatbot with Gemini API in Flutter

This Flutter project is a fully-featured chatbot that utilizes the [Gemini API](https://ai.google.dev/) to provide interactive and intelligent conversational experiences. This chatbot can memorize past interactions, save chats in local storage, and allows users to interact with images from their camera and gallery.

## Features

- **Chatbot Integration**: Real-time chatbot responses via the Gemini API.
- **Memory Support**: The chatbot remembers past conversations, making interactions more contextual and personalized.
- **Local Storage**: Save chat history securely using local storage.
- **Image Integration**: Capture images from the camera or pick images from the gallery to enhance interaction.
  
## Use


https://github.com/user-attachments/assets/62fa9ae8-1e7a-427d-81b1-ab36fc770002


## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/maliknomi0/chatbot.git
   ```
   
2. **Navigate to the project directory:**
   ```bash
   cd chatbot
   ```

3. **Install the dependencies:**
   ```bash
   flutter pub get
   ```

## Dependencies

The main dependencies used in this project include:

- `flutter_gemini: ^2.0.5`: For handling chat interactions via the Gemini API.
- `image_picker: ^1.1.2`: For selecting images from the gallery or taking new ones with the camera.
- `flutter_secure_storage: ^9.2.2`: For securely saving chat data locally.

Ensure all dependencies are up to date by running:

```bash
flutter pub upgrade
```

## Configuration

1. **Gemini API Key**: You’ll need to obtain a Gemini API key. Add it to your environment variables or securely store it within the app.
   
   Example:
   ```dart
   const String GEMINI_API_KEY = "your_api_key_here";
   ```

2. **Permissions**:
   - Ensure you have added permissions for camera and storage access in `AndroidManifest.xml` and `Info.plist` for Android and iOS, respectively.
   
   Example (for Android):
   ```xml
   <uses-permission android:name="android.permission.CAMERA"/>
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   ```

## Usage

Once installed, you can run the app on a simulator or physical device:

```bash
flutter run
```

### Main Functionalities:

1. **Start Chatting**: Open the chat interface and start interacting with the Gemini-powered chatbot.
2. **Memory-Persistent Chat**: Your conversation history is stored securely and retrieved across sessions.
3. **Image Interaction**:
   - Take a picture directly within the app using your camera.
   - Choose an existing photo from your gallery for interaction with the bot.

## Contact

Feel free to reach out with any questions, suggestions, or feedback.

- GitHub: [github.com/maliknomi0](https://github.com/maliknomi0)
- LinkedIn: [linkedin.com/in/maliknomi0](https://www.linkedin.com/in/maliknomi0/)
- WhatsApp: +92 370 0204207
