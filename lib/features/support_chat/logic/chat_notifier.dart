import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tayssir/common/data/configs.dart';
import '../data/ai_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatState({required this.messages, this.isLoading = false});

  ChatState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final aiService = ref.watch(aiServiceProvider);
  final configs = ref.watch(configsProvider).valueOrNull;
  final welcomeMessage = configs?.titoWelcomeMessage ?? "أهلاً بك يا بطل! أنا تيتو، كيفاش نقدر نعاونك اليوم بخصوص قرايتك أو اشتراكك؟ 🐬✨";
  
  return ChatNotifier(aiService, welcomeMessage: welcomeMessage);
});

class ChatNotifier extends StateNotifier<ChatState> {
  final AIService _aiService;
  final String welcomeMessage;

  ChatNotifier(this._aiService, {required this.welcomeMessage}) : super(ChatState(messages: [
    ChatMessage(
      text: welcomeMessage,
      isUser: false,
      timestamp: DateTime.now(),
    )
  ]));

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(text: text, isUser: true, timestamp: DateTime.now());
    state = state.copyWith(messages: [...state.messages, userMessage], isLoading: true);

    // Prepare history for Gemini
    final history = state.messages
        .skip(1) // Skip our UI welcome message
        .take(state.messages.length > 1 ? state.messages.length - 2 : 0) // exclude welcome and current message
        .map((m) => m.isUser ? Content.text(m.text) : Content.model([TextPart(m.text)]))
        .toList();

    final responseText = await _aiService.getResponse(text, history);

    final assistantMessage = ChatMessage(text: responseText, isUser: false, timestamp: DateTime.now());
    state = state.copyWith(messages: [...state.messages, assistantMessage], isLoading: false);
  }
}
