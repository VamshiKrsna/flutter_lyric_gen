import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> fetchLyrics(String description) async {
  await dotenv.load(fileName: ".env");
  String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? "API KEY NOT FOUND";
  final Model = GenerativeModel(
    model: "gemini-1.5-pro",
    apiKey: apiKey,
  );
  final prompt =
      "Generate lyrics for the song with the following description (description contains genre, Language and description.): $description";

  try {
    final response = await Model.generateContent([Content.text(prompt)]);
    return response.text!;
  } catch (error) {
    print("Error: $error");
    return "Error generating lyrics.";
  }
}

void main() async {
  String description =
      "A sad song about lost love in the pop genre"; // Example description
  String lyrics = await fetchLyrics(description);
  print("Generated Lyrics: $lyrics");
}
