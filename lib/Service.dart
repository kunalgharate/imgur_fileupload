
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class Service{

  Future<int> submitSubscription({required File file,required String filename,required String token})async{
    ///MultiPart request
    var request = http.MultipartRequest(
      'POST', Uri.parse("https://api.imgur.com/3/upload"),

    );
    Map<String,String> headers={
      "Authorization":"Bearer $token",
      "Content-type": "multipart/form-data"
    };
    request.files.add(
      http.MultipartFile(
        'image',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: filename,
        contentType: MediaType('image','jpeg'),
      ),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
      "album":"PDz6rYO",
    });
    try {
      var res = await request.send();
      // Read the response as a string
      var responseString = await http.Response.fromStream(res);
      // Parse the string as JSON
      var jsonResponse = json.decode(responseString.body);

      print("JSON Response: $jsonResponse");

      return responseString.statusCode;
    } catch (e) {
      print("Error uploading file: $e");
      return -1; // You can handle the error as needed
    }
   // return res.statusCode;
  }
}