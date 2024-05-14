import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendMessageToFCM(String token, String title, String body) async {
  var serverKey = 'AAAA0GL8r0U:APA91bFFNFvAXuNaCc4KEtYByq4l6brXo_eZWvfkub8ZFB4CgedIpbk_JkS6bgDeSFk8aKH0CW11X1a7ia1YpuutJ1OJETjY6IRjghUNpyi1Hc7yF817chy_CzpSwhP8Cze7LwEdloUG'; // Replace with your actual FCM server key

  var headers = <String, String>{
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  var message = jsonEncode({
    'notification': {
      'title': title,
      'body': body
    },
    'to': token,
  });

  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: message,
    );

  } catch (e) {}
}