// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TableExtension extends StatefulWidget {
  @override
  _TableExtensionState createState() => _TableExtensionState();
}

class _TableExtensionState extends State<TableExtension> {
  File? selectedFile;
  List<List<dynamic>> tableData = [];
  bool loading = false;
  String? error;
  bool isDialogOpen = false;

  String? token =
      "84226ca0b3a35babba70122c7a4baec327400c38"; // Replace with token from storage

  void handleFileChange() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        error = null;
      });
    }
  }

// for converting tabele ############################################################################
  Future<void> handleExtractTable() async {
    if (token == null || token!.isEmpty) {
      setState(() {
        isDialogOpen = true;
      });
      return;
    }

    if (selectedFile == null) {
      setState(() {
        error = "Please upload a PDF or image file to extract tables.";
      });
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      bool isPdf = selectedFile!.path.endsWith('.pdf');
      FormData formData = FormData.fromMap({
        isPdf ? "file" : "image":
            await MultipartFile.fromFile(selectedFile!.path),
      });

      Response response = await Dio().post(
        isPdf
            ? "https://ocr.goodwish.com.np/api/pdf-table-extraction/"
            : "https://ocr.goodwish.com.np/api/images/",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Token $token",
          },
        ),
      );

      // Parse imagedata from response
      List<dynamic> rawTables = response.data["imagedata"];
      List<List<dynamic>> parsedTables = rawTables
          .map((table) {
            return List<List<dynamic>>.generate(
              table.length,
              (index) => List<dynamic>.from(table["$index"]),
            );
          })
          .expand((e) => e)
          .toList();

      setState(() {
        tableData = parsedTables;
      });
    } catch (e) {
      print(" failed to extract datra  : $e");
      setState(() {
        error = "Failed to extract table data. Please try again.";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

// to doload the excel ##################
// void handleDownloadExcel() {
//   if (tableData.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("No table data available to download.")),
//     );
//     return;
//   }

//   var excel = Excel.createExcel();
//   Sheet sheet = excel['Sheet1'];

//   // Iterate through the tableData and convert each row
//   for (int rowIndex = 0; rowIndex < tableData.length; rowIndex++) {
//     var row = tableData[rowIndex];

//     // Convert each element to a string (or compatible type) and add it to the sheet
//     if (row is List) {
//       sheet.appendRow(
//         row.map((cell) => CellValue.from(cell.toString())).toList(),
//       );
//     } else {
//       // If the row is not a list, wrap it in a list
//       sheet.appendRow([CellValue.from(row.toString())]);
//     }
//   }

//   // Save the Excel file
//   List<int>? bytes = excel.save();
//   if (bytes != null) {
//     String filePath = "${Directory.systemTemp.path}/extracted_tables.xlsx";
//     File(filePath).writeAsBytesSync(bytes);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Excel file saved to $filePath")),
//     );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Failed to save Excel file.")),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    // seting the size of the screen########################
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // for picking files from devies ##################################################
                InkWell(
                  onTap: () {
                    handleFileChange();
                  },
                  child: SizedBox(
                    height: height * 0.04,
                    width: width * 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 21, 90, 147),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: Colors.blue[900],
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Text(
                            "UPLOAD FILE",
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),

                // show the name of file if it is choesen ###########################################
                if (selectedFile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                        "Selected File: ${selectedFile!.path.split('/').last}"),
                  ),

                // error will be shoned here ###########################################################
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(error!, style: TextStyle(color: Colors.red)),
                  ),

                // button for the converting the table nad API###################################3

                // ElevatedButton(
                //   onPressed: loading ? null : handleExtractTable,
                //   child: loading
                //       ? SpinKitThreeBounce(color: Colors.black, size: 20.0)
                //       : Text("Extract Table"),
                // ),

                SizedBox(
                  height: height * 0.06,
                  width: width * 0.5,
                  child: InkWell(
                    onTap: () {
                      loading ? null : handleExtractTable();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 26, 89, 205),
                          borderRadius: BorderRadius.circular(8)),
                      child: loading
                          ? SpinKitThreeBounce(color: Colors.black, size: 20.0)
                          : Center(
                              child: Text(
                              "EXTRACT TABLE",
                              style: TextStyle(color: Colors.white),
                            )),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),

                if (tableData.isNotEmpty)
                  Center(
                    child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: tableData[0].map((header) {
                                return DataColumn(label: Text(header));
                              }).toList(),
                              rows: tableData
                                  .skip(1)
                                  .map((row) => DataRow(
                                        cells: row
                                            .map((cell) => DataCell(Text(cell)))
                                            .toList(),
                                      ))
                                  .toList(),
                            ),
                          ),
                        )),
                  ),

                // to do excel
                ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.download),
                  label: Text("Download Excel"),
                ),
                ElevatedButton(
                    onPressed: () {
                      print("$tableData");
                    },
                    child: Text(" data ")),
                if (isDialogOpen)
                  AlertDialog(
                    title: Text("Login Required"),
                    content: Text(
                        "You need to be logged in to access this feature."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, "/auth"),
                        child: Text("Login"),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            print("$tableData");
                          },
                          child: Text(" data "))
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
