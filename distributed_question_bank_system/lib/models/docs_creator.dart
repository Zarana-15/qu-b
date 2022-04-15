import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:distributed_question_bank_system/constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> saveTopdf() async {
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.Center(
            child: pw.Text("Questions\n\n\n"),
          ),
          pw.ListView.builder(
              itemBuilder: (context, index) {
                return pw.Column(children: [
                  pw.Text("Q${index + 1}  " + questIndex[index].question),
                  (questIndex[index].type != 'Theory' ||
                          questIndex[index].type != 'T/F' ||
                          questIndex[index].type != 'FIB')
                      ? pw.ListView.builder(
                          direction: pw.Axis.vertical,
                          itemBuilder: (context, ind) {
                            return (index == 0)
                                ? pw.Text("Options: 1" +
                                    questIndex[index].options[ind])
                                : pw.Text("${ind + 1}" +
                                    questIndex[index].options[ind]);
                          },
                          itemCount: questIndex[index].options.length)
                      : pw.Container(),
                  pw.Text("Answer: " + questIndex[index].answer.toString()),
                  pw.Text('\n\n')
                ]);
              },
              itemCount: questIndex.length)
        ]); // Center
      })); // Page
  final bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement()
    ..href = url
    ..style.display = 'none'
    ..download = 'Questions.pdf';
  html.document.body?.children.add(anchor);
  anchor.click();
  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
