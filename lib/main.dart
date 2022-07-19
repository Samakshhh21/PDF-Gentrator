
import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? myfile;
  ImagePicker image = ImagePicker();

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      myfile = io.File(img!.path);
    });
  }

  getImageCam() async {
    var img = await image.pickImage(source: ImageSource.camera);
    setState(() {
      myfile = io.File(img!.path);
    });
  }

  Future<Uint8List> generatePdf(PdfPageFormat format, myfile) async {
    final pdf = pw.Document(compress: true, version: PdfVersion.pdf_1_5);
    final myimage = pw.MemoryImage(myfile.readAsBytesSync());
     pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
            child: pw.Image(myimage, fit: pw.BoxFit.contain),
          );
        },
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Maker'),
          actions: [
            ElevatedButton(onPressed: getImage, child: Icon(Icons.image)),
            ElevatedButton(onPressed: getImageCam, child: Icon(Icons.camera)),
          ],
        ),
          body: myfile == null
            ? Container()
            : PdfPreview(
              build: ((format) => generatePdf(format, myfile)),
            )
      ),
    );
  }
}
