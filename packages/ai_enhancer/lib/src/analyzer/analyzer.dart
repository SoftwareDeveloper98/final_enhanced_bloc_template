import 'dart:io';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

class ProjectAnalyzer {
  final String projectRoot;

  ProjectAnalyzer(this.projectRoot);

  Future<void> analyze() async {
    final dartFiles = await _findDartFiles();
    for (final file in dartFiles) {
      print('Analyzing: ${file.path}');
      final result = await parseFile(
        path: file.path,
        featureSet: FeatureSet.latestLanguageVersion(),
      );
      final visitor = _MyAstVisitor();
      result.unit.visitChildren(visitor);
    }
  }

  Future<List<File>> _findDartFiles() async {
    final files = <File>[];
    final rootDir = Directory(projectRoot);
    await for (final entity in rootDir.list(recursive: true, followLinks: false)) {
      if (entity is File &&
          entity.path.endsWith('.dart') &&
          !entity.path.contains('.g.dart') &&
          !entity.path.contains('.freezed.dart') &&
          !entity.path.contains(p.join(projectRoot, 'packages/ai_enhancer'))) {
        files.add(entity);
      }
    }
    return files;
  }
}

class _MyAstVisitor extends RecursiveAstVisitor<void> {
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    print('  Found class: ${node.name.lexeme}');
    super.visitClassDeclaration(node);
  }
}
