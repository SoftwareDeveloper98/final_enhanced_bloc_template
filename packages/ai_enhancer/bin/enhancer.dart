import 'package:ai_enhancer/src/analyzer/analyzer.dart';
import 'package:args/args.dart';
import 'dart:io';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('review')
    ..addCommand('apply');

  final argResults = parser.parse(arguments);

  if (argResults.command == null) {
    print('Usage: enhancer <command> [options]');
    print('Available commands: review, apply');
    exit(1);
  }

  final command = argResults.command!.name;

  switch (command) {
    case 'review':
      print('Running review command...');
      final projectRoot = Directory.current.path;
      final analyzer = ProjectAnalyzer(projectRoot);
      await analyzer.analyze();
      break;
    case 'apply':
      print('Running apply command...');
      // TODO: Implement apply logic
      break;
    default:
      print('Unknown command: $command');
      exit(1);
  }
}
