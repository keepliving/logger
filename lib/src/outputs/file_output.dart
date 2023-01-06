import 'dart:convert';
import 'dart:io';

import 'package:logger/src/logger.dart';
import 'package:logger/src/log_output.dart';

/// Writes the log output to a file.
class FileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink? _sink;
  final bool alwaysFlush;

  FileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
    this.alwaysFlush = true,
  });

  @override
  void init() {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  @override
  void output(OutputEvent event) {
    _sink?.writeAll(event.lines, '\n');
    _sink?.writeln();
    if (alwaysFlush) {
      _sink?.flush();
    }
  }

  @override
  void destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }

  void flush() async {
    await _sink?.flush();
  }
}
