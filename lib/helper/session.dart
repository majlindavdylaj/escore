import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session {

  FlutterSecureStorage? _storage;

  Session(){
    _storage = const FlutterSecureStorage();
  }

  setCookie(response) async {
    String? rawCookie = response.headers['set-cookie'];
    if(rawCookie != null) {
      await _storage!.write(key: "cookie", value: rawCookie);
    }
  }

  Future<Map<String, String>> cookie() async {
    Map<String, String> headers = {};

    String? rawCookie = await _storage!.read(key: 'cookie');
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
    return headers;
  }

  logout() async {
    await _storage!.deleteAll();
  }

}