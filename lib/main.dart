// upload to git hub with all changes and ui

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dio Package Tutorial',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                button(getData, 'Get Data', Colors.lightGreen),
                button(postData, 'Post Data', Colors.deepPurple),
                button(getAndPostData, 'Get / Post Data', Colors.pink),
                button(updateData, 'Update Data', Colors.blue),
                button(patchData, 'Patch Data', Colors.amber),
                button(deleteData, 'Delete Data', Colors.orange),
                button(downloadFile, 'Download File', Colors.brown),
                button(uploadFile, 'Upload File', Colors.red),
                button(uploadPDF, 'Upload PDF', Colors.teal),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget button(VoidCallback function, String buttonTitle, Color color) {
  return TextButton(
    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(color)),
    onPressed: function,
    child: Text(buttonTitle, style: TextStyle(color: Colors.white)),
  );
}

void getData() async {
  var dio = Dio();
  var response = await dio.get("https://jsonplaceholder.typicode.com/todos/1");
  print(response.statusCode);
  print(response.data.toString());
}

void postData() async {
  var dio = Dio();
  var response = await dio.post(
    "https://jsonplaceholder.typicode.com/posts",
    data: {'name': 'Waleed', 'email': 'waleedtaj420@gmail.com'},
  );
  print(response.statusCode);
  print(response.data.toString());
}

void getAndPostData() async {
  var dio = Dio();
  var response = await Future.wait([
    dio.get('https://jsonplaceholder.typicode.com/posts/1'),
    dio.post('https://jsonplaceholder.typicode.com/posts'),
  ]);
  print(response.length);
  print(response[0].data);
  print(response[1].data);
}

void updateData() async {
  var dio = Dio();
  var response = await dio.put(
    "https://jsonplaceholder.typicode.com/posts/1",
    data: {'name': 'Waleed', 'email': 'waleedtaj420@gmail.com'},
  );
  print(response.data);
}

void patchData() async {
  var dio = Dio();
  var response = await dio.get("https://jsonplaceholder.typicode.com/posts/1");
  var response2 = await dio.patch(
    "https://jsonplaceholder.typicode.com/posts/1",
    data: {'title': 'Waleed'},
  );
  print(response.data);
  print(response2.data);
}

void deleteData() async {
  var dio = Dio();
  var response = await dio.get("https://jsonplaceholder.typicode.com/posts/2");
  var response2 = await dio.delete(
    "https://jsonplaceholder.typicode.com/posts/2",
  );
  print(response.statusCode);
  print(response2.statusCode);
}

void downloadFile() async {
  var dio = Dio();
  Directory directory = await getApplicationDocumentsDirectory();
  var response = await dio.download(
    "https://filesamples.com/samples/document/txt/sample1.txt",
    '${directory.path}/downloadedFile.txt',
  );
  print(response.statusCode);
}

Future uploadFile() async {
  var dio = Dio();
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    File file = File(result.files.single.path ?? " ");
    String filename = file.path.split('/').last;
    String filepath = file.path;

    FormData data = FormData.fromMap({
      'key': 'your-api-key',
      'image': await MultipartFile.fromFile(filepath, filename: filename),
      'name': 'waleed.jpg',
    });

    var response = await dio.post(
      "https://api.imgbb.com/1/upload",
      data: data,
      onSendProgress: (int sent, int total) {
        print('$sent, $total');
      },
    );
    print(response.data);
  } else {
    print('result is null');
  }
}

void uploadPDF() async {
  var dio = Dio();
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path ?? ' ');
    String fileName = file.path.split('/').last;
    String filePath = file.path;

    FormData data = FormData.fromMap({
      'x-api-key': 'your-api-key',
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });

    var response = await dio.post(
      'https://api.pdf.co/v1/file/upload',
      data: data,
      onSendProgress: (int send, int total) {
        print('$send from $total');
      },
    );
    print(response.data);
  } else {
    print('result is null');
  }
}
