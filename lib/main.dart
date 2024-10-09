import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:async';
void main() => runApp(LyricsApp());

class LyricsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LyricsGeneratorPage(),
    );
  }
}

class LyricsGeneratorPage extends StatefulWidget {
  @override
  _LyricsGeneratorPageState createState() => _LyricsGeneratorPageState();
}

class _LyricsGeneratorPageState extends State<LyricsGeneratorPage> {
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _lyricsController = TextEditingController();


  void _generateLyrics() async {
    String description = _descriptionController.text;
    String generatedLyrics = await fetchLyrics(description);
    setState(() {
      _lyricsController.text = generatedLyrics;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lyrics Generator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _languageController,
              decoration: InputDecoration(labelText: 'Language'),
            ),
            TextField(
              controller: _genreController,
              decoration: InputDecoration(labelText: 'Genre'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Describe the song',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateLyrics,
              child: Text('Create/Update Lyrics'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _lyricsController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Generated Lyrics',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> fetchLyrics(String inputDescription) async {
    // return "Generated lyrics based on: $description";
    await dotenv.load(fileName: ".env");
    String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? "API KEY NOT FOUND";
    List<String> parts = inputDescription.split(",");
    // if (parts.length < 2) {
    //   return "Error generating lyrics";
    // }
    String genre = parts[0].trim();
    String language = parts[1].trim();
    String description = parts.sublist(2).join(", ").trim();  
    final Model = GenerativeModel(
      model: "gemini-1.5-pro" ,
      apiKey: apiKey
    );
    final prompt = '''
      Generate original song lyrics based on the following details : 
      - Genre : $genre
      - Language : $language
      - Description : $description
''';
    final response = await Model.generateContent([Content.text(prompt)]);
    print("$genre, $language, $description");
    return response.text! ;
  }
}
