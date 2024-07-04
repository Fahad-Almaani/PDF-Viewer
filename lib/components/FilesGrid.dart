import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../pages/pdfview.dart';

class FileGrid extends StatefulWidget {
  const FileGrid({super.key});

  @override
  State<FileGrid> createState() => _FileGridState();
}

class _FileGridState extends State<FileGrid> {
  List<File> _pdfFiles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchPDFs();
  }

  Future<void> _fetchPDFs() async {
    if (await _requestPermission(Permission.manageExternalStorage)) {
      // Common directories to check
      List<Directory> directories = [
        await getExternalStorageDirectory() ?? Directory(''),
        Directory('/storage/emulated/0/Download'), // Common download directory
        Directory(
            '/storage/emulated/0/Documents'), // Common documents directory
        Directory('/storage/emulated/0') // Root of internal storage
      ];

      for (Directory dir in directories) {
        if (dir.existsSync()) {
          print('Checking directory: ${dir.path}');
          try {
            List<FileSystemEntity> files =
                await dir.list(recursive: true).toList();
            print('Files found in ${dir.path}: ${files.length}');

            setState(() {
              _pdfFiles.addAll(files
                  .where((file) => file is File && file.path.endsWith('.pdf'))
                  .map((file) => file as File)
                  .toList());
            });
          } catch (e) {
            print('Error listing files in ${dir.path}: $e');
          }
        } else {
          print('Directory does not exist: ${dir.path}');
        }
      }

      print('Total PDF files found: ${_pdfFiles.length}');
    } else {
      print('Required permissions are not granted');
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }

  void goToPDFViewer(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Pdfview(initialFilePath: path)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _pdfFiles.isEmpty
        ? Text("No PDF files found")
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0),
                itemCount: _pdfFiles.length,
                itemBuilder: (context, index) {
                  File pdfFile = _pdfFiles[index];
                  return GestureDetector(
                    onTap: () => {goToPDFViewer(pdfFile.path)},
                    child: GridTile(
                        child: Icon(Icons.picture_as_pdf, size: 50.0),
                        footer: GridTileBar(
                          backgroundColor: Colors.black54,
                          title: Text(
                            pdfFile.path.split('/').last,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        )),
                  );
                }),
          );
  }
}
