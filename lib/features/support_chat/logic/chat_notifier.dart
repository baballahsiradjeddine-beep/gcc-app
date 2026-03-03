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
  
  return ChatNotifier(aiService, welcomeMessage: welcomeMessage, configs: configs);
});

class ChatNotifier extends StateNotifier<ChatState> {
  final AIService _aiService;
  final String welcomeMessage;
  final ConfigModel? configs;

  ChatNotifier(this._aiService, {required this.welcomeMessage, this.configs}) : super(ChatState(messages: [
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

    // Check for instant answers from configs
    String? instantAnswer;
    if (configs != null) {
      final t = text.trim();
      if (t == "كم سعر الاشتراك؟" || t.contains("سعر الاشتراك")) {
        instantAnswer = configs!.titoSubscriptionPrice;
      } else if (t == "ما هي المواد المتاحة؟" || t.contains("المواد المتاحة")) {
        instantAnswer = configs!.titoAvailableMaterials;
      } else if (t == "ما هو هدف التطبيق؟" || t.contains("هدف التطبيق")) {
        instantAnswer = configs!.titoAppGoal;
      } else if (t == "كيف أتواصل معكم؟" || t.contains("كيف أتواصل") || t.contains("مواقع التواصل")) {
        instantAnswer = configs!.titoSocialLinks;
      }
    }

    if (instantAnswer != null && instantAnswer.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 600)); // Smooth feeling
      final assistantMessage = ChatMessage(text: instantAnswer, isUser: false, timestamp: DateTime.now());
      state = state.copyWith(messages: [...state.messages, assistantMessage], isLoading: false);
      return;
    }

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
