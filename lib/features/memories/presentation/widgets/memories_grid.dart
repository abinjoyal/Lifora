import 'package:flutter/material.dart';
import '../../domain/entities/memory.dart';
import 'memory_card.dart';

class MemoriesGrid extends StatelessWidget {
  const MemoriesGrid({
    super.key,
    required this.memories,
    required this.onTapMemory,
    required this.onToggleFavorite,
  });

  final List<Memory> memories;
  final ValueChanged<Memory> onTapMemory;
  final ValueChanged<Memory> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.76,
      ),
      itemCount: memories.length,
      itemBuilder: (context, index) {
        final memory = memories[index];
        return MemoryCard(
          memory: memory,
          onTap: () => onTapMemory(memory),
          onToggleFavorite: () => onToggleFavorite(memory),
        );
      },
    );
  }
}
