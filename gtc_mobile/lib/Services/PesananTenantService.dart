import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gtc_mobile/Models/PesananTenantModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PesananTenantsService {
  static final Dio _dio = Dio();
  static final String url = dotenv.env['API_URL']!;

  static Future<PesananTenantModel> createPesanan(
      PesananTenantModel pesananTenant) async {
    try {
      final response = await _dio.post(
        '$url/api/pesanan',
        data: pesananTenant.toJson(),
      );
      debugPrint(response.toString());
      if (response.statusCode == 201) {
        return PesananTenantModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to create pesanan: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error creating pesanan: $e');
      rethrow;
    }
  }

  static Future<int?> getMaxIdPesanan() async {
    try {
      final response = await _dio.get('$url/api/pesanan/max-id-pesanan');
      if (response.statusCode == 200 && response.data != null) {
        return response.data['idPesanan'] as int?;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getting max idPesanan: $e');
      rethrow;
    }
  }
}
