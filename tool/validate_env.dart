import 'dart:io';

import 'package:disciple/app/core/constants/app_constants.dart';

enum _KeyKind { text, url, bundleId }

Map<String, _KeyKind> _resolveRequired() => {
  AppConstants.apiBaseUrl: _KeyKind.url,
  AppConstants.appName: _KeyKind.text,
  AppConstants.keycloakFrontendUrl: _KeyKind.url,
  AppConstants.keycloakClientId: _KeyKind.text,
  AppConstants.keycloakClientRealm: _KeyKind.text,
  AppConstants.keycloakBundleIdentifier: _KeyKind.bundleId,
  AppConstants.googleApiKey: _KeyKind.text,
  AppConstants.socketIoUrl: _KeyKind.url,
};

Map<String, String> _parseEnv(File file) {
  final out = <String, String>{};
  for (final raw in file.readAsLinesSync()) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final eq = line.indexOf('=');
    if (eq < 0) continue;
    final key = line.substring(0, eq).trim();
    var value = line.substring(eq + 1).trim();
    if (value.length >= 2 &&
        ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'")))) {
      value = value.substring(1, value.length - 1);
    }
    out[key] = value;
  }
  return out;
}

String? _appAuthRedirectScheme() {
  final gradle = File('android/app/build.gradle');
  if (!gradle.existsSync()) return null;
  final match = RegExp(
    r'''["']appAuthRedirectScheme["']\s*:\s*["']([^"']+)["']''',
  ).firstMatch(gradle.readAsStringSync());
  return match?.group(1);
}

// RFC 3986 scheme: ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
// Keycloak's URI parser rejects schemes containing other characters (notably underscore).
final _rfc3986Scheme = RegExp(r'^[A-Za-z][A-Za-z0-9+\-.]*$');

int _validate(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('❌ $path not found');
    return 1;
  }

  final env = _parseEnv(file);
  final required = _resolveRequired();
  final errors = <String>[];
  final warnings = <String>[];

  for (final entry in required.entries) {
    final key = entry.key;
    final kind = entry.value;
    final value = env[key];

    if (value == null) {
      errors.add('missing key: $key');
      continue;
    }
    if (value.isEmpty) {
      errors.add('empty value for: $key');
      continue;
    }
    if (value.endsWith(' not_found') || value == '$key not_found') {
      errors.add('placeholder value for: $key ($value)');
      continue;
    }

    switch (kind) {
      case _KeyKind.url:
        final uri = Uri.tryParse(value);
        if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
          errors.add('invalid URL for $key: $value');
        } else if (uri.scheme != 'https') {
          warnings.add('$key is not https: $value');
        }
      case _KeyKind.bundleId:
        if (!_rfc3986Scheme.hasMatch(value)) {
          errors.add(
            '$key ($value) contains characters not allowed in a URI scheme '
            '(RFC 3986: ALPHA / DIGIT / "+" / "-" / "." only) — '
            "Keycloak's URI parser will reject this",
          );
        }
        final scheme = _appAuthRedirectScheme();
        if (scheme != null && scheme != value) {
          errors.add(
            '$key ($value) does not match appAuthRedirectScheme ($scheme) '
            'in android/app/build.gradle',
          );
        }
      case _KeyKind.text:
        break;
    }
  }

  final expectedKeys = required.keys.toSet();
  final extras = env.keys.toSet().difference(expectedKeys);
  for (final extra in extras) {
    warnings.add('unknown key (ignored by app): $extra');
  }

  for (final w in warnings) {
    stdout.writeln('⚠️  $path: $w');
  }

  if (errors.isEmpty) {
    stdout.writeln(
      '✅ $path: all ${required.length} required keys present and valid',
    );
    return 0;
  }

  stderr.writeln('❌ $path has validation errors:');
  for (final e in errors) {
    stderr.writeln('  • $e');
  }
  return 1;
}

void main(List<String> args) {
  final paths = args.isEmpty ? const ['.env'] : args;
  var failures = 0;
  for (final p in paths) {
    failures += _validate(p);
  }
  if (failures > 0) exit(1);
}
