// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // Troque pela sua URL real. Em Android Emulator use 10.0.2.2,
  // em iOS Simulator use localhost, em device físico use o IP da máquina.
  static const String _baseUrl = 'https://dummyjson.com';
  // static final String _baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:8080';

  /// Retorna o token JWT em caso de sucesso.
  /// Lança [Exception] com mensagem legível em caso de falha.
  Future<String> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // Ajuste a chave conforme o contrato da sua API ('token', 'access_token', etc.)
      final token = data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('Token não encontrado na resposta.');
      }
      return token;
    } else if (response.statusCode == 401) {
      throw Exception('E-mail ou senha incorretos.');
    } else {
      throw Exception('Erro do servidor (${response.statusCode}).');
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