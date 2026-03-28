class EtapaSugerida {
  final String nombre;
  final int duracionDias;
  final List<String> tareas;

  const EtapaSugerida({
    required this.nombre,
    required this.duracionDias,
    required this.tareas,
  });

  factory EtapaSugerida.fromJson(Map<String, dynamic> json) => EtapaSugerida(
        nombre: json['nombre'] as String,
        duracionDias: json['duracion_dias'] as int,
        tareas: List<String>.from(json['tareas'] as List),
      );
}

class PlanSugerido {
  final String titulo;
  final int duracionDias;
  final List<EtapaSugerida> etapas;

  const PlanSugerido({
    required this.titulo,
    required this.duracionDias,
    required this.etapas,
  });

  factory PlanSugerido.fromJson(Map<String, dynamic> json) => PlanSugerido(
        titulo: json['titulo'] as String,
        duracionDias: json['duracion_dias'] as int,
        etapas: (json['etapas'] as List)
            .map((e) => EtapaSugerida.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// Mensaje en el chat
class ChatMensaje {
  final String rol; // 'user' | 'assistant'
  final String texto;
  final PlanSugerido? plan; // solo en mensajes del asistente con plan

  const ChatMensaje({
    required this.rol,
    required this.texto,
    this.plan,
  });
}