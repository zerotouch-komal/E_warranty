import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MyHttpResponse {
  final bool success;
  final String body;
  final String error;

  MyHttpResponse({required this.success, this.body = "", this.error = ""});
}

class HttpHelper {
  static Future<Map<String, String>> getHeaders() async {
    String? token = SharedPreferenceHelper.instance.getString('token');

    Map<String, String> headers = {
      'Authorization': "Bearer $token",
      'Referer': baseUrl
    };

    return headers;
  }

  static Future<MyHttpResponse> get(String url) async {
    try {
      final response =
          await http.get(Uri.parse(baseUrl + url), headers: await getHeaders());
      return handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  static Future<MyHttpResponse> post(String url, dynamic body) async {
    try {
      final response = await http.post(Uri.parse(baseUrl + url),
          body: body, headers: await getHeaders());
      return handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  static Future<MyHttpResponse> put(String url, dynamic body) async {
    try {
      final response = await http.put(Uri.parse(baseUrl + url),
          body: body, headers: await getHeaders());
      return handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  static Future<MyHttpResponse> delete(String url) async {
    try {
      final response = await http.delete(Uri.parse(baseUrl + url),
          headers: await getHeaders());
      return handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  static Future<MyHttpResponse> postMultipart(
      String url, Map<String, String> fields, List<XFile> files) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));
      request.headers.addAll(await getHeaders());
      request.fields.addAll(fields);

      for (XFile file in files) {
        request.files.add(await http.MultipartFile.fromPath(
          'file', // Adjust the field name according to your API requirement
          file.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return handleResponse(response);
    } catch (error) {
      return MyHttpResponse(success: false, error: error.toString());
    }
  }

  static MyHttpResponse handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return MyHttpResponse(success: true, body: response.body);
    } else {
      return MyHttpResponse(
        success: false,
        error: 'Error ${response.statusCode}: ${response.reasonPhrase}',
      );
    }
  }
}
