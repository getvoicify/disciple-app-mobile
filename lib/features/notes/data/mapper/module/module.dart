import 'package:disciple/features/notes/data/mapper/note_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the NoteToCompanionMapper.
final noteToCompanionMapperProvider = Provider<NoteToCompanionMapper>(
  (ref) => NoteToCompanionMapper(),
);
