import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _printFileDetails(PlatformFile file) {
    final mimeType = file.path != null ? lookupMimeType(file.path!) : null;
    final contentType = mimeType != null ? MediaType.parse(mimeType) : null;

    debugPrint('''
        ****************************
        File name: ${file.name}
        File bytes: ${file.bytes}
        File size: ${file.size}
        File extension: ${file.extension}
        File path: ${file.path}
        File MIME type: $mimeType
        File Content-type: $contentType
        ****************************
        ''');
  }

  Future<void> _chooseSingleFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );

    if (result != null) {
      final file = result.files.first;
      _printFileDetails(file);
    } else {
      debugPrint('User didn\'t choose single file');
    }
  }

  Future<void> _chooseFilteredSingleFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = result.files.first;
      _printFileDetails(file);
    } else {
      debugPrint('User didn\'t choose single file');
    }
  }

  Future<void> _chooseMultipleFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      for (final file in result.files) {
        _printFileDetails(file);
      }
    } else {
      debugPrint('User didn\'t choose any files');
    }
  }

  Future<void> _chooseDirectory() async {
    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      debugPrint('''
      ****************************
      Directory path: $directoryPath
      ****************************
      ''');
    } else {
      debugPrint('User didn\'t choose directory');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('file_picker playground'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _chooseSingleFile,
              child: const Text('Choose single file'),
            ),
            ElevatedButton(
              onPressed: _chooseFilteredSingleFile,
              child: const Text('Choose filtered single file'),
            ),
            ElevatedButton(
              onPressed: _chooseMultipleFiles,
              child: const Text('Choose multiple files'),
            ),
            ElevatedButton(
              onPressed: _chooseDirectory,
              child: const Text('Choose directory to open'),
            ),
          ],
        ),
      ),
    );
  }
}
