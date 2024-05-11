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

  static Future<List<TenantMenuModel>> getTenantMenuList(String nama_tenant) async{
    try{
      final response = await _dio.get(url + "/api/getMenuByTenant/" + nama_tenant);
      debugPrint(url);
      debugPrint(response.toString());
      final List<dynamic> data = response.data;
      return data.map((tenantMenu) => TenantMenuModel.fromJson(tenantMenu)).toList();
    } catch(e){
      debugPrint(e.toString());
      throw Exception('Failed to load tenant menu');
    }
  }
}