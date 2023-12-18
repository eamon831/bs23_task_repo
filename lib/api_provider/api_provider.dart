import 'dart:io';
import 'dart:convert' show json, utf8;

import 'package:bs23_task/database/database_helper.dart';
import 'package:bs23_task/model/repository.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class ApiProvider {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  static final HttpClient _httpClient = HttpClient();
  static final String _url = "https://api.github.com";

  Future<bool?> fetchRepositoryList({String? query}) async {
    final uri = Uri.parse('$_url/search/repositories').replace(
      queryParameters: {
        'q': query,
        'sort': 'stars',
        'order': 'desc',
      },
    );
    toast("Uri Is ready");
    final jsonResponse = await _getJson(uri);
    print(jsonResponse);

    if (jsonResponse == null) {
      return null;
    }
    if (jsonResponse['errors'] != null) {
      return null;
    }
    if (jsonResponse['items'] == null) {
      return null;
    }
   await  databaseHelper.insertList(deleteBeforeInsert: true,tableName:DatabaseHelper.table_repository,dataList:Repository.mapJSONStringToList(jsonResponse['items']).map((e) => e.toJson()).toList());
   return true;
  }

  static Future<Map<String, dynamic>?> _getJson(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      print(httpRequest.uri.toString());
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.OK) {
        return null;
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}
