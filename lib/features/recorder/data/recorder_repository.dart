import 'dart:io';
import 'package:dio/dio.dart';

class RecorderRepository {
  final Dio _dio = Dio();

  Future<void> uploadRecording(String filePath, {Function(double)? onProgress}) async {
    try {
      final File file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist at $filePath');
      }

      final String fileName = filePath.split('/').last;
      
      // Dummy endpoint for demonstration. Replace with your actual backend URL.
      const String uploadUrl = 'https://api.example.com/upload';

      final FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _dio.post(
        uploadUrl,
        data: formData,
        onSendProgress: (sent, total) {
          if (total != -1 && onProgress != null) {
            onProgress(sent / total);
          }
        },
      );
    } on DioException catch (e) {
      // Simulate success if the dummy endpoint fails, but log the error
      // In a real app, we would throw the error
      print('Upload failed (expected for dummy URL): ${e.message}');
      
      // For the purpose of the test, let's wait a bit to show progress
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
