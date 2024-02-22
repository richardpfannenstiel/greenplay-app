import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunicationService {
  static final shared = CommunicationService();

  final _serverURL = "https://server.pic-dev.ase.in.tum.de";

  Future<http.Response> get(String path) async {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    try {
      final response = await http.get(Uri.parse('$_serverURL/$path'),
          headers: token != null ? {"Authorization": "Bearer $token"} : {});
      if (response.statusCode == 200) {
        return Future.value(response);
      } else {
        return Future.error(
            Exception("Status ${response.statusCode}: ${response.body}"));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<http.Response> post(String path, [body]) async {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    try {
      final response = await http.post(Uri.parse('$_serverURL/$path'),
          body: body,
          headers: token != null ? {"Authorization": "Bearer $token"} : {});
      if (response.statusCode == 200) {
        return Future.value(response);
      } else {
        return Future.error(
            Exception("Status ${response.statusCode}: ${response.body}"));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<http.Response> put(String path, [body]) async {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    try {
      final response = await http.put(Uri.parse('$_serverURL/$path'),
          body: body,
          headers: token != null ? {"Authorization": "Bearer $token"} : {});
      if (response.statusCode == 200) {
        return Future.value(response);
      } else {
        return Future.error(
            Exception("Status ${response.statusCode}: ${response.body}"));
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
