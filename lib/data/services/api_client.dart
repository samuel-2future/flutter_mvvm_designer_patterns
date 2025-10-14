import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final Uri? uri;
  final String? responseBody;

  ApiException(this.message, {this.statusCode, this.uri, this.responseBody});

  @override
  String toString() =>
      'ApiException(status: $statusCode, uri: $uri, message: $message, body: $responseBody)';
}

typedef JsonParser<T> = T Function(dynamic json);

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final Duration timeout;
  final http.Client _client;

  ApiClient({
    required this.baseUrl,
    Map<String, String>? headers,
    Duration? timeout,
    http.Client? httpClient,
  })  : defaultHeaders = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
    ...?headers,
  },
        timeout = timeout ?? const Duration(seconds: 20),
        _client = httpClient ?? http.Client();

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final uri = Uri.parse(baseUrl);
    final resolved = uri.resolve(path.startsWith('/') ? path.substring(1) : path);
    return resolved.replace(
      queryParameters: {
        ...resolved.queryParameters,
        if (query != null)
          ...query.map((k, v) => MapEntry(k, v?.toString() ?? '')),
      },
    );
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {...defaultHeaders, ...?headers};
  }

  Future<T> get<T>(
      String path, {
        Map<String, dynamic>? query,
        Map<String, String>? headers,
        required JsonParser<T> parser,
      }) async {
    final uri = _buildUri(path, query);
    try {
      final resp = await _client
          .get(uri, headers: _mergeHeaders(headers))
          .timeout(timeout);
      return _handleResponse(resp, parser, uri);
    } on TimeoutException {
      throw ApiException('Tempo de requisição excedido', uri: uri);
    }
  }

  Future<T> post<T>(
      String path, {
        Object? body,
        Map<String, dynamic>? query,
        Map<String, String>? headers,
        required JsonParser<T> parser,
      }) async {
    final uri = _buildUri(path, query);
    try {
      final resp = await _client
          .post(
        uri,
        headers: _mergeHeaders(headers),
        body: body is String ? body : jsonEncode(body),
      )
          .timeout(timeout);
      return _handleResponse(resp, parser, uri);
    } on TimeoutException {
      throw ApiException('Tempo de requisição excedido', uri: uri);
    }
  }

  Future<T> put<T>(
      String path, {
        Object? body,
        Map<String, dynamic>? query,
        Map<String, String>? headers,
        required JsonParser<T> parser,
      }) async {
    final uri = _buildUri(path, query);
    try {
      final resp = await _client
          .put(
        uri,
        headers: _mergeHeaders(headers),
        body: body is String ? body : jsonEncode(body),
      )
          .timeout(timeout);
      return _handleResponse(resp, parser, uri);
    } on TimeoutException {
      throw ApiException('Tempo de requisição excedido', uri: uri);
    }
  }

  Future<void> delete(
      String path, {
        Map<String, dynamic>? query,
        Map<String, String>? headers,
      }) async {
    final uri = _buildUri(path, query);
    try {
      final resp =
      await _client.delete(uri, headers: _mergeHeaders(headers)).timeout(timeout);
      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        throw ApiException(
          'Erro ao deletar',
          statusCode: resp.statusCode,
          uri: uri,
          responseBody: resp.body,
        );
      }
    } on TimeoutException {
      throw ApiException('Tempo de requisição excedido', uri: uri);
    }
  }

  T _handleResponse<T>(http.Response resp, JsonParser<T> parser, Uri uri) {
    final code = resp.statusCode;
    dynamic decoded;

    if (resp.body.isNotEmpty) {
      try {
        decoded = jsonDecode(resp.body);
      } catch (_) {
        // quando a API retorna texto puro
        decoded = resp.body;
      }
    }

    if (code >= 200 && code < 300) {
      return parser(decoded);
    }

    throw ApiException(
      'Erro HTTP',
      statusCode: code,
      uri: uri,
      responseBody: resp.body,
    );
  }

  void close() => _client.close();
}
