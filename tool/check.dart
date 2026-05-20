import 'dart:io';

Future<void> main(List<String> arguments) async {
  final quick = arguments.contains('--quick');
  final pathsToFormat = _existingPaths(['lib', 'test', 'tool']);

  if (!quick) {
    await _run('flutter', ['pub', 'get']);
    await _run('dart', [
      'run',
      'build_runner',
      'build',
    ]);
  }

  if (pathsToFormat.isNotEmpty) {
    await _run('dart', ['format', '--set-exit-if-changed', ...pathsToFormat]);
  }

  await _run('flutter', ['analyze']);

  if (!quick) {
    await _run('flutter', ['test']);
    await _run('dart', ['run', 'dependency_validator']);
  }
}

List<String> _existingPaths(List<String> paths) {
  return paths.where((path) => Directory(path).existsSync()).toList();
}

Future<void> _run(String executable, List<String> arguments) async {
  final command = [executable, ...arguments].join(' ');
  stdout.writeln('\n> $command');

  final result = await Process.start(
    executable,
    arguments,
    mode: ProcessStartMode.inheritStdio,
    runInShell: Platform.isWindows,
  );

  final exitCode = await result.exitCode;
  if (exitCode != 0) {
    stderr.writeln('\nCommand failed with exit code $exitCode: $command');
    exit(exitCode);
  }
}
