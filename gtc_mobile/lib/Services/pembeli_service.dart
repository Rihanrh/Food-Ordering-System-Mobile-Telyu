import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gtc_mobile/Models/pembeli_model.dart';

class AkunPembeliService {
  static final Dio _dio = Dio();
  static String url = dotenv.env['API_URL']!;

  static Future<PembeliModel?> getPembeli(String deviceId) async {
    try {
      final response = await _dio.get(url + '/api/pembelis/$deviceId');
      debugPrint(response.toString());
      if (response.statusCode == 200) {
        return PembeliModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        // Handle not found scenario: return null
        return null;
      } else {
        throw Exception(
            'Failed to get pembeli (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint(e.toString()); // Optional: Log the actual error for debugging
      // Don't throw an exception here if you've handled specific cases before
      return null;
    }
  }

  static Future<PembeliModel> createPembeli(String deviceId) async {
    try {
      final response =
          await _dio.post(url + '/api/pembelis', data: {'device_id': deviceId});
      debugPrint(response.toString());
      if (response.statusCode == 201) {
        return PembeliModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create pembeli');
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
