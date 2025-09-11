import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  final String className;
  final bool printCallingFunctionName;
  final bool printCallStack;
  final List<String> excludeLogsFromClasses;
  final String? showOnlyClass;

  SimpleLogPrinter(
    this.className, {
    this.printCallingFunctionName = true,
    this.printCallStack = false,
    this.excludeLogsFromClasses = const [],
    this.showOnlyClass,
  });

  static const Map<Level, String> levelEmojis = {
    Level.trace: '🔍',
    Level.debug: '🐛',
    Level.info: '📢',
    Level.warning: '🔧',
    Level.error: '❌',
    Level.fatal: '💀',
  };

  static final Map<Level, AnsiColor> levelColors = {
    Level.trace: const AnsiColor.fg(45),
    Level.debug: const AnsiColor.fg(46),
    Level.info: const AnsiColor.fg(51),
    Level.warning: const AnsiColor.fg(220),
    Level.error: const AnsiColor.fg(202),
    Level.fatal: const AnsiColor.fg(129),
  };
  @override
  List<String> log(LogEvent event) {
    final AnsiColor? color = levelColors[event.level];

    final String emoji = levelEmojis[event.level] ?? '📜';
    final String? methodName = _getMethodName();

    final String methodNameSection =
        printCallingFunctionName && methodName != null ? ' | $methodName' : '';
    final String stackLog = event.stackTrace.toString();

    final String output =
        '$emoji [$className$methodNameSection] ${DateTime.now().toLocal().monthTime} - ${event.message}'
        '${event.error != null ? '\n❗ ERROR: ${event.error}\n' : ''}'
        '${printCallStack ? '\n📌 STACKTRACE:\n$stackLog' : ''}';

    if (excludeLogsFromClasses.any(
          (excludeClass) => className == excludeClass,
        ) ||
        (showOnlyClass != null && className != showOnlyClass)) {
      return [];
    }

    final pattern = RegExp('.{1,800}');
    final List<String> result = [];

    for (final line in output.split('\n')) {
      result.addAll(
        pattern.allMatches(line).map((match) {
          if (kReleaseMode) {
            return match.group(0)!;
          } else {
            return color!(match.group(0)!);
          }
        }),
      );
    }

    return result;
  }

  String? _getMethodName() {
    try {
      final currentStack = StackTrace.current;
      final formattedStacktrace = _formatStackTrace(currentStack, 3);
      if (kIsWeb) {
        final classNameParts = _splitClassNameWords(className);
        return _findMostMatchedTrace(
          formattedStacktrace!,
          classNameParts,
        ).split(' ').last;
      } else {
        final realFirstLine = formattedStacktrace?.firstWhere(
          (line) => line.contains(className),
          orElse: () => "",
        );

        final methodName = realFirstLine?.replaceAll('$className.', '');
        return methodName;
      }
    } catch (e) {
      return null;
    }
  }

  List<String> _splitClassNameWords(String className) => className
      .split(RegExp(r'(?=[A-Z])'))
      .map((e) => e.toLowerCase())
      .toList();

  String _findMostMatchedTrace(
    List<String> stackTraces,
    List<String> keyWords,
  ) {
    String match = stackTraces.firstWhere(
      (trace) => _doesTraceContainsAllKeywords(trace, keyWords),
      orElse: () => '',
    );
    if (match.isEmpty) {
      match = _findMostMatchedTrace(
        stackTraces,
        keyWords.sublist(0, keyWords.length - 1),
      );
    }
    return match;
  }

  bool _doesTraceContainsAllKeywords(String stackTrace, List<String> keywords) {
    final formattedKeywordsAsRegex = RegExp(keywords.join('.*'));
    return stackTrace.contains(formattedKeywordsAsRegex);
  }
}

final stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

List<String>? _formatStackTrace(StackTrace stackTrace, int methodCount) {
  final lines = stackTrace.toString().split('\n');

  final formatted = <String>[];
  var count = 0;
  for (final line in lines) {
    final match = stackTraceRegex.matchAsPrefix(line);
    if (match != null) {
      if (match.group(2)!.startsWith('package:logger')) {
        continue;
      }
      final newLine = ("${match.group(1)}");
      formatted.add(newLine.replaceAll('<anonymous closure>', '()'));
      if (++count == methodCount) {
        break;
      }
    } else {
      formatted.add(line);
    }
  }

  if (formatted.isEmpty) {
    return null;
  } else {
    return formatted;
  }
}

Logger getLogger(
  String className, {
  bool printCallingFunctionName = true,
  bool printCallstack = false,
  List<String> excludeLogsFromClasses = const [],
  String? showOnlyClass,
}) => Logger(
  printer: SimpleLogPrinter(
    className,
    printCallingFunctionName: printCallingFunctionName,
    printCallStack: printCallstack,
    showOnlyClass: showOnlyClass,
    excludeLogsFromClasses: excludeLogsFromClasses,
  ),
  output: MultiOutput([if (kDebugMode) ConsoleOutput()]),
);
