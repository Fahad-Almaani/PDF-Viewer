import 'package:flutter/material.dart';
import 'package:pdfviewer/components/AppBar.dart';
import 'package:pdfviewer/components/FilesGrid.dart';

import 'pdfview.dart';
import 'package:file_picker/file_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _filePath;
  Future<void> _pickPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                Pdfview(initialFilePath: result.files.single.path!),
          ),
        );
      });
    }
  }

  late StreamSubscription _intentSub;

  final _sharedFiles = <SharedMediaFile>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);

        ReceiveSharingIntent.instance.reset();
        goToPDFViewer(_sharedFiles[0].path);
      });
    });
    WidgetsBinding.instance.addObserver;
  }

  void goToPDFViewer(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Pdfview(initialFilePath: path)),
    );
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver;
    _intentSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: FileGrid(),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[800],
        onPressed: () {
          _pickPDFFile();
        },
        child: Icon(
          Icons.open_in_browser,
          color: Colors.white,
        ),
        elevation: 20,
      ),
    );
  }
}
