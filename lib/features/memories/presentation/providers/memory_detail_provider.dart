import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/memory.dart';
import 'memory_provider.dart';

final memoryDetailProvider = FutureProvider.autoDispose.family<Memory?, String>(
  (ref, id) async {
    final getMemoryById = ref.watch(getMemoryByIdUseCaseProvider);
    return getMemoryById(id);
  },
);
