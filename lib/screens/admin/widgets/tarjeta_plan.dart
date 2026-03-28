import 'package:flutter/material.dart';
import '../../../models/chat_models.dart';

class TarjetaPlan extends StatelessWidget {
  final PlanSugerido plan;
  final VoidCallback onCrear;
  final VoidCallback onAjustar;

  const TarjetaPlan({
    super.key,
    required this.plan,
    required this.onCrear,
    required this.onAjustar,
  });

  static const _morado = Color(0xFF534AB7);
  static const _moradoClaro = Color(0xFFEEEDFE);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0DFD8), width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: _moradoClaro,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(plan.titulo,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF3C3489))),
              const SizedBox(height: 2),
              Text('${plan.duracionDias} días · ${plan.etapas.length} etapas',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF534AB7))),
            ]),
          ),
          // Etapas
          ...plan.etapas.asMap().entries.map((entry) {
            final i = entry.key;
            final etapa = entry.value;
            return Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE0DFD8), width: 0.5))),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 22, height: 22,
                  decoration: const BoxDecoration(color: _morado, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('${i + 1}',
                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(etapa.nombre,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 3),
                  Text('${etapa.duracionDias} días · ${etapa.tareas.join(', ')}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF888780)),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ])),
              ]),
            );
          }),
          // Botones
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(
                child: FilledButton(
                  onPressed: onCrear,
                  style: FilledButton.styleFrom(
                    backgroundColor: _morado,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  child: const Text('Crear este plan'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: onAjustar,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: Color(0xFFE0DFD8), width: 0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  child: const Text('Ajustar', style: TextStyle(color: Color(0xFF1A1A1A))),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}