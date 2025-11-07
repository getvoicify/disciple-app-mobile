import 'package:flutter/material.dart';

class TextHighlighter {
  static List<TextSpan> highlight({
    required String text,
    required String searchTerm,
    required TextStyle normalStyle,
    required TextStyle highlightStyle,
  }) {
    if (searchTerm.isEmpty) {
      return [TextSpan(text: text, style: normalStyle)];
    }

    final List<TextSpan> spans = [];
    int start = 0;
    int indexOfSearchTerm;

    while ((indexOfSearchTerm = text.toLowerCase().indexOf(
          searchTerm.toLowerCase(),
          start,
        )) !=
        -1) {
      // Add normal text before the match
      if (indexOfSearchTerm > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, indexOfSearchTerm),
            style: normalStyle,
          ),
        );
      }

      // Add the highlighted match
      final matchText = text.substring(
        indexOfSearchTerm,
        indexOfSearchTerm + searchTerm.length,
      );
      spans.add(TextSpan(text: matchText, style: highlightStyle));

      // Update the start index
      start = indexOfSearchTerm + searchTerm.length;
    }

    // Add remaining normal text
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: normalStyle));
    }

    return spans;
  }
}
