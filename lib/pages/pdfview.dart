import 'package:flutter/material.dart';
import 'package:pdfviewer/components/AppBar.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

// import 'package:share_plus/share_plus.dart';
class Pdfview extends StatefulWidget {
  final String initialFilePath;
  const Pdfview({super.key, required this.initialFilePath});

  @override
  State<Pdfview> createState() => _PdfviewState();
}

class _PdfviewState extends State<Pdfview> {
  late PdfControllerPinch pdfControllerPinch;
  int totalPageCount = 0, currentPage = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pdfControllerPinch = PdfControllerPinch(
        document: PdfDocument.openFile(widget.initialFilePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: widget.initialFilePath.split('/').last,
      ),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[800],
        onPressed: () {
          _sharePDF(widget.initialFilePath);
        },
        child: const Icon(
          Icons.share,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _sharePDF(String pdfFilepath) async {
    try {
      await Share.shareXFiles([XFile('$pdfFilepath')],
          text: 'Check out this PDF file!');
    } catch (e) {
      print('Error sharing file: $e');
    }
  }

  Widget _buildUI() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  pdfControllerPinch.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.linear);
                },
                icon: Icon(Icons.arrow_back)),
            Text("Pages: $currentPage/$totalPageCount"),
            IconButton(
                onPressed: () {
                  pdfControllerPinch.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.linear);
                },
                icon: Icon(Icons.arrow_forward)),
          ],
        ),
        _pdfView(),
      ],
    );
  }

  Widget _pdfView() {
    return Expanded(
        child: PdfViewPinch(
      controller: pdfControllerPinch,
      onDocumentLoaded: (doc) {
        setState(() {
          totalPageCount = doc.pagesCount;
        });
      },
      onPageChanged: (page) {
        setState(() {
          currentPage = page;
        });
      },
    ));
  }
}
