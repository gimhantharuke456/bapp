import 'package:bapp/views/cart/my.cart.view.dart';
import 'package:bapp/views/cart/myitems.list.view.dart';
import 'package:bapp/views/home/home.view.dart';
import 'package:bapp/views/orderview/my.orders.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  late FlutterTts flutterTts;
  late stt.SpeechToText speechToText;
  bool isListening = false;

  VoiceService() {
    flutterTts = FlutterTts();
    speechToText = stt.SpeechToText();
  }

  // Text-to-Speech
  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  // Speech-to-Text
  Future<void> initializeSpeech() async {
    bool available = await speechToText.initialize(
      onError: (val) => print('onError: $val'),
      onStatus: (val) => print('onStatus: $val'),
    );
    if (!available) {
      throw Exception('The speech recognition service is not available.');
    }
  }

  Future<void> startListening({
    required Function(String text) onResult,
    Function()? onListeningStarted,
    Function()? onListeningFinished,
  }) async {
    isListening = true;
    onListeningStarted?.call();
    await speechToText.listen(
      onResult: (result) => onResult(result.recognizedWords),
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 5),
      cancelOnError: true,
      partialResults: true,
      onSoundLevelChange: (level) => print('soundLevel: $level'),
      onDevice: true,
    );
  }

  Future<void> stopListening({
    Function()? onListeningFinished,
  }) async {
    await speechToText.stop();
    isListening = false;
    onListeningFinished?.call();
  }

  // Navigation
  void navigate(String command, BuildContext context) {
    if (command.toLowerCase().contains('my orders') ||
        command.toLowerCase() == 'orders') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyOrdersView()),
      );
    }

    if (command.toLowerCase().contains('my cart') ||
        command.toLowerCase() == 'cart') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyCartView()),
      );
    }

    if (command.toLowerCase().contains('my list') ||
        command.toLowerCase() == 'list') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyItemList()),
      );
    }

    if (command.toLowerCase().contains('home') ||
        command.toLowerCase() == 'home view') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    }
  }
}
