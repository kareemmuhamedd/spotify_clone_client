import 'dart:io';
import 'package:client/core/constants/server_constants.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<void> uploadSong(
      File selectedImage,
      File selectedAudio,
      ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ServerConstants.serverUrl}/song/upload'),
    );
    request
      ..files.addAll(
        [
          await http.MultipartFile.fromPath(
            'song',
            selectedAudio.path,
          ),
          await http.MultipartFile.fromPath(
            'thumbnail',
            selectedImage.path,
          ),

        ],
      )
      ..fields.addAll(
        {
          'artist': 'Kareem Muhammad', // Ensure this matches the server's expected field name
          'song_name': 'Kemo', // Ensure this matches the server's expected field name
          'hex_code': 'FFFFFF', // Ensure this matches the server's expected field name
        },
      )
      ..headers.addAll(
        {
          'x-auth-token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlOTQ2MzYxLTk0NjMtNDA5OC05OGIwLTE1Yzc3ODhjMTM4ZSJ9.zdNUdfwTJIFjcfeVmyJLDxhEq-Gms87ColPYses_Z4k', // Ensure this matches the server's expected header
        },
      );
    final res = await request.send();

    print(res);
  }
}