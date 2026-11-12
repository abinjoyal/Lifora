import 'package:flutter/material.dart';
import '../../domain/entities/memory.dart';
import 'memory_list_item.dart';

class MemoriesList extends StatelessWidget {
  const MemoriesList({
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
    return ListView.builder(
      padding: const EdgeInsets.only(top: 6.0, bottom: 20.0),
      itemCount: memories.length,
      itemBuilder: (context, index) {
        final memory = memories[index];
        return MemoryListItem(
          memory: memory,
          onTap: () => onTapMemory(memory),
          onToggleFavorite: () => onToggleFavorite(memory),
        );
      },
    );
  }
}
