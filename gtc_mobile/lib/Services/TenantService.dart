import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gtc_mobile/Models/TenantModel.dart';
import 'package:gtc_mobile/Models/TenantMenuModel.dart';
import 'dart:convert';

class TenantService {
  static final Dio _dio = Dio();
  static String url = dotenv.env['API_URL']!;

  static Future<List<TenantModel>> getTenantList() async {
    try {
      final response = await _dio.get(url + "/api/tenants");
      debugPrint(url);
      debugPrint(response.toString());
      final List<dynamic> data = response.data;
      return data.map((tenant) => TenantModel.fromJson(tenant)).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to load tenant names');
    }
  }

  static Future<TenantModel> getTenant(int idTenant) async {
    try {
      final response = await _dio.get(url + "/api/tenants/$idTenant");
      debugPrint(url);
      debugPrint(response.toString());
      final dynamic data = response.data;
      return TenantModel.fromJson(data);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to load tenant by id');
    }
  }

  static Future<String> getTenantNameById(int idTenant) async {
    try {
      TenantModel tenant = await getTenant(idTenant);
      return tenant.nama_tenant;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to load tenant name by id');
    }
  }

  static Future<List<TenantMenuModel>> getTenantMenuList(int tenantId) async {
    try {
      final response = await _dio.get(url + "/api/getMenuByTenant/$tenantId");
      debugPrint(url);
      debugPrint(response.toString());
      final List<dynamic> data = response.data;
      return data
          .map((tenantMenu) => TenantMenuModel.fromJson(tenantMenu))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to load tenant menu');
    }
  }

  static Future<TenantMenuModel> getTenantMenuById(
      int idTenant, int idMenu) async {
    try {
      final response =
          await _dio.get(url + "/api/getMenuById/$idTenant/$idMenu");
      debugPrint(url);
      debugPrint(response.toString());
      final dynamic data = response.data;
      return TenantMenuModel.fromJson(data);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to load tenant menu by id');
    }
  }
}
