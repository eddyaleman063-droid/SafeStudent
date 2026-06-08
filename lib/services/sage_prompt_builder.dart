import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/chat_message.dart';
import '../models/sage_personality_profile.dart';

class SagePromptBuilder {
  Content buildSystemInstruction() {
    return Content.system(SagePersonalityProfile.getSystemPrompt());
  }

  List<Content> buildContents(List<ChatMessage> messages) {
    return messages.map((m) {
      final role = m.role == ChatRole.user ? 'user' : 'model';
      return Content(role, [TextPart(m.text)]);
    }).toList();
  }
}
