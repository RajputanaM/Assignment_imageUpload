import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late File? _image= null;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

    Future<void> uploadImage() async {
  final uri = Uri.parse('https://codelime.in/api/remind-app-token');
  final dio = Dio();
  final formData = FormData.fromMap({
    'image': await MultipartFile.fromFile(_image!.path,
        filename: _image!.path.split('/').last),
  });

  try {
    final response = await dio.post(uri.toString(), data: formData);
    // if (response.statusCode == 200) {
      print('Image uploaded');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image uploaded'),
          duration: Duration(seconds: 3),
        ),
      );
    // } else {
    //   print('Image upload failed');
    // }
  } catch (error) {
    print(error.toString());
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: _image == null
                ? const Text('No image selected.')
                : Image.network(_image!.path),
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: getImage,
            child: const Text('Select Image'),
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: _image == null ? null : uploadImage,
            child: const Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
