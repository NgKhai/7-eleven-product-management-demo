part of product_management_app;

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(this.baseUrl);
  final String baseUrl;
  String? token;

  Future<void> restoreToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
  }

  Future<void> saveToken(String nextToken) async {
    token = nextToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', nextToken);
  }

  Future<void> clearToken() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final cleanQuery = <String, String>{};
    query?.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        cleanQuery[key] = value.toString();
      }
    });
    return Uri.parse('$baseUrl$path').replace(queryParameters: cleanQuery.isEmpty ? null : cleanQuery);
  }

  Future<Map<String, dynamic>> _send(Future<http.Response> request) async {
    final response = await request.timeout(const Duration(seconds: 20));
    final body = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300 || body['success'] == false) {
      throw ApiException(body['message']?.toString() ?? 'Request failed');
    }
    return body;
  }

  Future<Map<String, dynamic>> get(String path, [Map<String, dynamic>? query]) {
    return _send(http.get(_uri(path, query), headers: _headers));
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) {
    return _send(http.post(_uri(path), headers: _headers, body: jsonEncode(body)));
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) {
    return _send(http.put(_uri(path), headers: _headers, body: jsonEncode(body)));
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body) {
    return _send(http.patch(_uri(path), headers: _headers, body: jsonEncode(body)));
  }

  Future<Map<String, dynamic>> delete(String path) {
    return _send(http.delete(_uri(path), headers: _headers));
  }

  Future<Map<String, dynamic>> multipart(
    String method,
    String path,
    Map<String, String> fields,
    List<PickedImage> images,
  ) async {
    final request = http.MultipartRequest(method, _uri(path));
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll(fields);
    for (final image in images) {
      request.files.add(http.MultipartFile.fromBytes('images', image.bytes, filename: image.name));
    }
    final streamed = await request.send().timeout(const Duration(seconds: 40));
    final response = await http.Response.fromStream(streamed);
    return _send(Future.value(response));
  }
}
