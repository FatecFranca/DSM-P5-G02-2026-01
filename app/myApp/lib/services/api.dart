// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static const String _baseUrl = 'https://api-qualquer.canadacentral.cloudapp.azure.com';

  static String? token;
  static int? userId;

  static Map<String, dynamic> _decodeJwtPayload(String jwt) {
    final payload = jwt.split('.')[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  Future<String> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final jwt = data['token'] as String?;
      if (jwt == null || jwt.isEmpty) {
        throw Exception('Token não encontrado na resposta.');
      }
      token = jwt;
      userId = _decodeJwtPayload(jwt)['id_usuario'] as int?;
      return jwt;
    } else if (response.statusCode == 401) {
      throw Exception('E-mail ou senha incorretos.');
    } else {
      throw Exception('Erro do servidor (${response.statusCode}).');
    }
  }

  Future<void> register(String nome, String email, String hashSenha) async {
    final url = Uri.parse('$_baseUrl/usuarios');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email, 'hash_senha': hashSenha}),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> updateUsuario({String? nome, String? email, String? senha}) async {
    if (userId == null || token == null) {
      throw Exception('Usuário não autenticado.');
    }

    final url = Uri.parse('$_baseUrl/usuarios/$userId');
    final body = <String, String>{};
    if (nome != null && nome.isNotEmpty) body['nome'] = nome;
    if (email != null && email.isNotEmpty) body['email'] = email;
    if (senha != null && senha.isNotEmpty) body['senha'] = senha;

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Sessão expirada. Faça login novamente.');
    } else {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchUserData(String token) async {
    final url = Uri.parse('$_baseUrl/user');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw Exception('Sessão expirada. Faça login novamente.');
    } else {
      throw Exception('Erro ao buscar dados do usuário (${response.statusCode}).');
    }
  }
}