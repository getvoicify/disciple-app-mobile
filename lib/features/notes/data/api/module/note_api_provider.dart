import 'package:disciple/app/core/network/api_provider_factory.dart';
import 'package:disciple/features/notes/data/api/note_api.dart';

final noteApiProvider = createApiProvider<NoteApi>((dio) => NoteApi(dio));
