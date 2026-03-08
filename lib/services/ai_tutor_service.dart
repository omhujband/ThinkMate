import 'package:runanywhere/runanywhere.dart';

/// AI Tutor service that wraps RunAnywhere LLM with educational prompts
class AiTutorService {
  static const _quizSystemPrompt = '''You are a quiz generator for students. Generate exactly one multiple-choice question.

RULES:
- Output ONLY in this exact format, nothing else
- One question with exactly 4 options labeled A, B, C, D
- One correct answer letter
- A brief explanation

FORMAT:
Q: [question text]
A) [option A]
B) [option B]
C) [option C]
D) [option D]
ANSWER: [letter]
EXPLANATION: [brief explanation]''';

  static const _simplifierSystemPrompt = '''You are ThinkMate, a friendly AI tutor that simplifies complex topics for students.

RULES:
- Break down the concept into simple, easy-to-understand steps
- Use analogies and everyday examples
- Keep language simple and engaging
- Use numbered steps when explaining processes
- End with a brief summary''';

  static const _languagePracticePrompt = '''You are a language conversation partner for English practice.

RULES:
- Respond naturally to continue the conversation
- After your response, add a line starting with "FEEDBACK:" 
- In feedback, note any grammar or fluency improvements the user could make
- Keep responses conversational and encouraging
- If the user's message has errors, gently correct them in the feedback''';

  /// Generate a quiz question for the given subject and difficulty
  static Future<LLMStreamingResult> generateQuizQuestion({
    required String subject,
    required String difficulty,
    String? previousContext,
  }) async {
    final prompt = '''$_quizSystemPrompt

Subject: $subject
Difficulty: $difficulty
${previousContext != null ? 'Avoid repeating: $previousContext' : ''}

Generate a $difficulty $subject question now:''';

    return await RunAnywhere.generateStream(
      prompt,
      options: const LLMGenerationOptions(
        maxTokens: 300,
        temperature: 0.8,
      ),
    );
  }

  /// Simplify a complex concept
  static Future<LLMStreamingResult> simplifyConcept(String topic) async {
    final prompt = '''$_simplifierSystemPrompt

The student asks: "$topic"

Provide a clear, step-by-step explanation:''';

    return await RunAnywhere.generateStream(
      prompt,
      options: const LLMGenerationOptions(
        maxTokens: 512,
        temperature: 0.7,
      ),
    );
  }

  /// Generate a conversation response for language practice
  static Future<LLMStreamingResult> languageConversation({
    required String scenario,
    required String userMessage,
    String? conversationHistory,
  }) async {
    final prompt = '''$_languagePracticePrompt

Scenario: $scenario
${conversationHistory != null ? 'Previous conversation:\n$conversationHistory\n' : ''}
User: $userMessage

Respond naturally and provide feedback:''';

    return await RunAnywhere.generateStream(
      prompt,
      options: const LLMGenerationOptions(
        maxTokens: 300,
        temperature: 0.8,
      ),
    );
  }

  /// Parse a quiz question from LLM output
  static QuizQuestion? parseQuizQuestion(String raw) {
    try {
      final lines = raw.split('\n').where((l) => l.trim().isNotEmpty).toList();

      String question = '';
      final options = <String, String>{};
      String correctAnswer = '';
      String explanation = '';

      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.startsWith('Q:')) {
          question = trimmed.substring(2).trim();
        } else if (trimmed.startsWith('A)') || trimmed.startsWith('A.')) {
          options['A'] = trimmed.substring(2).trim();
        } else if (trimmed.startsWith('B)') || trimmed.startsWith('B.')) {
          options['B'] = trimmed.substring(2).trim();
        } else if (trimmed.startsWith('C)') || trimmed.startsWith('C.')) {
          options['C'] = trimmed.substring(2).trim();
        } else if (trimmed.startsWith('D)') || trimmed.startsWith('D.')) {
          options['D'] = trimmed.substring(2).trim();
        } else if (trimmed.startsWith('ANSWER:')) {
          correctAnswer = trimmed.substring(7).trim().toUpperCase();
          if (correctAnswer.length > 1) correctAnswer = correctAnswer[0];
        } else if (trimmed.startsWith('EXPLANATION:')) {
          explanation = trimmed.substring(12).trim();
        }
      }

      if (question.isEmpty || options.length < 4 || correctAnswer.isEmpty) {
        return null;
      }

      return QuizQuestion(
        question: question,
        options: options,
        correctAnswer: correctAnswer,
        explanation: explanation.isEmpty ? 'The correct answer is $correctAnswer.' : explanation,
      );
    } catch (_) {
      return null;
    }
  }
}

class QuizQuestion {
  final String question;
  final Map<String, String> options;
  final String correctAnswer;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}
