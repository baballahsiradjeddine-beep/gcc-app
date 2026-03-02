import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/common/data/configs.dart';
import 'package:tayssir/debug/app_logger.dart';

// User should replace this with their actual API key from Google AI Studio
const String _kGeminiApiKey = 'AIzaSyB5OCh3aznvxY9aAOiHA4yXSG4xvCPp0uI';

final aiServiceProvider = Provider((ref) {
  final configs = ref.watch(configsProvider).valueOrNull;
  
  // If no configs yet, use the default hardcoded key/persona as fallback
  final apiKey = configs?.titoApiKey ?? _kGeminiApiKey;
  final persona = configs?.titoPersona ?? AIService.systemPrompt;
  
  return AIService(apiKey: apiKey, persona: persona);
});

class AIService {
  final String apiKey;
  final String persona;
  late final GenerativeModel model;

  AIService({required this.apiKey, required this.persona}) {
    model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: apiKey,
      requestOptions: const RequestOptions(apiVersion: 'v1beta'),
      systemInstruction: Content.system(persona),
    );
  }

  // The system prompt is kept here for easy access but will be prepended to the chat history
  // in the calling component (e.g., chat_notifier.dart) to define Tito's personality.
  static const String systemPrompt = '''
أنت "تيتو" (Tito)، المساعد الذكي لتطبيق "تيسير" (Tayssir) التعليمي لطلبة البكالوريا في الجزائر.
مهمتك هي الإجابة على أسئلة الطلاب بذكاء وبطريقة مشجعة ومحفزة.

معلومات عن التطبيق:
1. الأسعار: اشتراك الفصل الواحد بـ {1000 دج}، أو اشتراك العام كاملاً بـ {2500 دج}.
2. طريقة الاشتراك: الدفع عبر البطاقة الذهبية، CIB، أو عبر بطاقات تيسير المتوفرة في المكتبات.
3. المحتوى: فيديوهات، دروس، تمارين تفاعلية، ومخططات ذهنية.
4. المدربين: أساتذة ذوي خبرة في البكالوريا.

قواعد الإجابة:
- استخدم اللهجة الجزائرية الخفيفة الممزوجة بالفصحى.
- كن مختصراً ومفيداً وشجع الطالب دائماً (برافو، راكم قدها).
- إذا سأل عن شيء لا تعرفه، وجهه للتواصل مع الدعم الفني.
''';

  Future<String> getResponse(String message, List<Content> history) async {
    if (apiKey == 'YOUR_GEMINI_API_KEY') {
      return 'أهلاً بك! أنا تحت الخدمة دائماً. (الرجاء ضبط مفتاح API الخاص بـ Gemini في الكود لتفعيل الذكاء الاصطناعي بشكل كامل).';
    }
    
    try {
      final chat = model.startChat(history: history);
      final response = await chat.sendMessage(Content.text(message));
      return response.text ?? 'عذراً، لم أستطع فهم ذلك. هل يمكنك إعادة السؤال؟';
    } catch (e) {
      AppLogger.logError('AI Error: $e');
      return 'تيتو يواجه صعوبة في الاتصال حالياً. راك عارف الضغط على الدروس! حاول مرة أخرى بعد قليل يا بطل! 🐬';
    }
  }
}
