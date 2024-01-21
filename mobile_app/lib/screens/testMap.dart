import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ImageTestScreen extends StatefulWidget {
  @override
  _ImageTestScreenState createState() => _ImageTestScreenState();
}

class _ImageTestScreenState extends State<ImageTestScreen> {
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    // Replace the URL with a known PNG image URL
    fetchAndDisplayImage('https://static.vecteezy.com/system/resources/thumbnails/027/254/720/small/colorful-ink-splash-on-transparent-background-png.png');
  }

  Future<void> fetchAndDisplayImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      setState(() {
        imageBytes = response.bodyBytes;
      });
    } else {
      print('Failed to fetch image. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Test'),
      ),
      body: Center(
        child: imageBytes != null
            ? Image.memory(
                imageBytes!,
                fit: BoxFit.cover,
                width: 300,
                height: 300,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}