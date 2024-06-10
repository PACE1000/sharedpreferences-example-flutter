import 'dart:convert';
import 'package:http/http.dart' as http;

class Session {
  Uri url = Uri.parse("http://10.31.17.207/coba2/");

  Map<String, String> headers = {};

  Future<Map> get(String urlString) async {
    Uri url = Uri.parse(urlString);
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<Map> post(String urlString, dynamic data) async {
    Uri url = Uri.parse(urlString);
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
