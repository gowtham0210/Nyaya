import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln(
      'Usage: dart run tool/new_feature_spec.dart "Feature Name" [feature-slug]',
    );
    exitCode = 64;
    return;
  }

  final featureName = args.first.trim();
  final featureSlug = args.length > 1 ? args[1].trim() : _slugify(featureName);

  if (featureName.isEmpty || featureSlug.isEmpty) {
    stderr.writeln('Feature name and slug must not be empty.');
    exitCode = 64;
    return;
  }

  final featuresDir = Directory('specs/features');
  final templatesDir = Directory('specs/templates');

  if (!templatesDir.existsSync()) {
    stderr.writeln('Missing specs/templates directory.');
    exitCode = 1;
    return;
  }

  featuresDir.createSync(recursive: true);

  final nextId = _nextFeatureId(featuresDir);
  final featureId = '${nextId.toString().padLeft(3, '0')}-$featureSlug';
  final featureDir = Directory('${featuresDir.path}/$featureId');

  if (featureDir.existsSync()) {
    stderr.writeln('Feature directory already exists: ${featureDir.path}');
    exitCode = 1;
    return;
  }

  featureDir.createSync(recursive: true);

  final replacements = <String, String>{
    '{{FEATURE_ID}}': featureId,
    '{{FEATURE_NAME}}': featureName,
    '{{DATE}}': _today(),
  };

  final templateMap = <String, String>{
    'feature-spec.md': 'spec.md',
    'technical-plan.md': 'plan.md',
    'tasks.md': 'tasks.md',
  };

  for (final entry in templateMap.entries) {
    final templateFile = File('${templatesDir.path}/${entry.key}');
    final outputFile = File('${featureDir.path}/${entry.value}');
    final contents = templateFile.readAsStringSync();
    outputFile.writeAsStringSync(_replaceAll(contents, replacements));
  }

  stdout.writeln('Created $featureId');
  stdout.writeln('  - ${featureDir.path}/spec.md');
  stdout.writeln('  - ${featureDir.path}/plan.md');
  stdout.writeln('  - ${featureDir.path}/tasks.md');
}

int _nextFeatureId(Directory featuresDir) {
  var maxId = 0;

  for (final entity in featuresDir.listSync()) {
    if (entity is! Directory) {
      continue;
    }

    final name = entity.uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .last;
    final parts = name.split('-');
    if (parts.isEmpty) {
      continue;
    }

    final maybeId = int.tryParse(parts.first);
    if (maybeId != null && maybeId > maxId) {
      maxId = maybeId;
    }
  }

  return maxId + 1;
}

String _slugify(String input) {
  final normalized = input
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
  return normalized;
}

String _replaceAll(String source, Map<String, String> replacements) {
  var result = source;
  for (final entry in replacements.entries) {
    result = result.replaceAll(entry.key, entry.value);
  }
  return result;
}

String _today() {
  final now = DateTime.now();
  final year = now.year.toString().padLeft(4, '0');
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
