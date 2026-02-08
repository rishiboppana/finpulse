// Quick test script to verify Gemini API key works
// Run with: dart run test_gemini_api.dart

import 'dart:convert';
import 'dart:io';

void main() async {
  const apiKey = 'AIzaSyCzcGbp5fqezc89lhF7ZkxKd_EaVag4VSk';
  const model = 'gemini-2.0-flash'; // Using Gemini 2.0 Flash as requested
  
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey'
  );
  
  final requestBody = jsonEncode({
    'contents': [
      {
        'parts': [
          {'text': 'Say "Hello FinPulse! API is working!" in a fun way.'}
        ]
      }
    ]
  });
  
  print('Testing Gemini API with model: $model');
  print('Sending request...\n');
  
  try {
    final httpClient = HttpClient();
    final request = await httpClient.postUrl(url);
    request.headers.set('Content-Type', 'application/json');
    request.write(requestBody);
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody);
      final text = jsonResponse['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? 'No text in response';
      
      print('✅ SUCCESS! API Key is working!\n');
      print('Response from Gemini:');
      print('-' * 40);
      print(text);
      print('-' * 40);
    } else {
      print('❌ ERROR: Status code ${response.statusCode}');
      print('Response: $responseBody');
    }
    
    httpClient.close();
  } catch (e) {
    print('❌ ERROR: $e');
  }
}
