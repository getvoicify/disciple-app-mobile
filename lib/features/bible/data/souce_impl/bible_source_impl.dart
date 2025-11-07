import 'dart:convert';

import 'package:disciple/features/bible/data/model/bible_model.dart';
import 'package:disciple/features/bible/domain/source/bible_source.dart';
import 'package:flutter/services.dart';

class BibleSourceImpl implements BibleSource {
  @override
  Future<BibleModel?> importBibles(String source) async {
    final jsonString = await rootBundle.loadString(
      'assets/bibles/$source.json',
    );
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    return BibleModel.fromJson(jsonData);
  }
}
