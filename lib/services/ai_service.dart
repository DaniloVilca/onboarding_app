import 'dart:convert';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────
//  Cambia aquí cuando tengas tu API key
// ─────────────────────────────────────────────
const _kProvider = AiProvider.mock; // .claude | .openai | .mock
const _kClaudeApiKey = 'sk-ant-xxxx';
const _kOpenAiApiKey = 'sk-xxxx';

enum AiProvider { claude, openai, mock }

class AiMessage {
  final String role; // 'user' | 'assistant'
  final String content;
  const AiMessage({required this.role, required this.content});
  Map<String, dynamic> toJson() => {'role': role, 'content': content};
}

class AiService {
  static Future<String> sendMessage({
    required List<AiMessage> history,
    required String systemPrompt,
  }) async {
    switch (_kProvider) {
      case AiProvider.claude:
        return _callClaude(history: history, systemPrompt: systemPrompt);
      case AiProvider.openai:
        return _callOpenAi(history: history, systemPrompt: systemPrompt);
      case AiProvider.mock:
        return _mockResponse(history.last.content);
    }
  }

  // ── Claude API ──────────────────────────────
  static Future<String> _callClaude({
    required List<AiMessage> history,
    required String systemPrompt,
  }) async {
    final res = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'x-api-key': _kClaudeApiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': 'claude-opus-4-5',
        'max_tokens': 1024,
        'system': systemPrompt,
        'messages': history.map((m) => m.toJson()).toList(),
      }),
    );
    if (res.statusCode != 200) throw Exception('Claude error: ${res.body}');
    final data = jsonDecode(res.body);
    return data['content'][0]['text'] as String;
  }

  // ── OpenAI API ──────────────────────────────
  static Future<String> _callOpenAi({
    required List<AiMessage> history,
    required String systemPrompt,
  }) async {
    final messages = [
      {'role': 'system', 'content': systemPrompt},
      ...history.map((m) => m.toJson()),
    ];
    final res = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $_kOpenAiApiKey',
        'content-type': 'application/json',
      },
      body: jsonEncode({'model': 'gpt-4o', 'messages': messages}),
    );
    if (res.statusCode != 200) throw Exception('OpenAI error: ${res.body}');
    final data = jsonDecode(res.body);
    return data['choices'][0]['message']['content'] as String;
  }

  // ── Mock (sin API key) ──────────────────────
  static Future<String> _mockResponse(String userMsg) async {
    await Future.delayed(const Duration(seconds: 1));
    return jsonEncode({
      'texto': 'Generé este plan de 3 semanas para el perfil que describes:',
      'plan': {
        'titulo': 'Onboarding — Analista de datos junior',
        'duracion_dias': 21,
        'etapas': [
          {
            'nombre': 'Bienvenida y cultura',
            'duracion_dias': 3,
            'tareas': ['Leer reglamento interno', 'Conocer valores de la empresa', 'Tour de herramientas']
          },
          {
            'nombre': 'Setup técnico',
            'duracion_dias': 5,
            'tareas': ['Configurar Git y entorno local', 'Obtener accesos a sistemas', 'Introducción a Notion']
          },
          {
            'nombre': 'Primer proyecto real',
            'duracion_dias': 13,
            'tareas': ['Crear dashboard demo', 'Revisión con líder técnico', 'Presentación al equipo']
          }
        ]
      }
    });
  }
}