import 'package:flutter/material.dart';
import '../../../models/chat_models.dart';

class BurbujaMensaje extends StatelessWidget {
  final ChatMensaje mensaje;
  const BurbujaMensaje({super.key, required this.mensaje});

  static const _morado = Color(0xFF534AB7);
  static const _moradoClaro = Color(0xFFEEEDFE);

  bool get _esBot => mensaje.rol == 'assistant';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _esBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment: _esBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _esBot ? Colors.white : _morado,
              border: _esBot ? Border.all(color: const Color(0xFFE0DFD8), width: 0.5) : null,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: _esBot ? const Radius.circular(4) : null,
                bottomRight: _esBot ? null : const Radius.circular(4),
              ),
            ),
            child: Text(
              mensaje.texto,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: _esBot ? const Color(0xFF1A1A1A) : _moradoClaro,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(_horaActual(), style: const TextStyle(fontSize: 10, color: Color(0xFF888780))),
        ],
      ),
    );
  }

  String _horaActual() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}