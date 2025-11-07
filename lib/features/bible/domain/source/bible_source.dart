import 'package:disciple/features/bible/data/model/bible_model.dart';

abstract class BibleSource {
  Future<BibleModel?> importBibles(String source);
}
