import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://cardio-predict-api.canadacentral.cloudapp.azure.com';
  static const _timeout = Duration(seconds: 15);

  static String? token;
  static int? userId;

  static void logout() {
    token = null;
    userId = null;
  }

  static Map<String, dynamic> _decodeJwtPayload(String jwt) {
    final payload = jwt.split('.')[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  static Future<http.Response> _send(Future<http.Response> request) async {
    try {
      return await request.timeout(_timeout);
    } on SocketException {
      throw Exception('Sem conexão com a internet. Verifique sua rede.');
    } on HandshakeException {
      throw Exception('Erro de segurança SSL. Verifique a conexão.');
    } on TimeoutException {
      throw Exception('Tempo limite esgotado. Verifique sua conexão.');
    }
  }

  Future<String> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    final response = await _send(http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': password}),
    ));

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
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['error'] as String? ?? 'Dados inválidos.');
    } else {
      throw Exception('Erro do servidor (${response.statusCode}).');
    }
  }

  Future<void> register(String nome, String email, String hashSenha) async {
    final url = Uri.parse('$_baseUrl/usuarios');

    final response = await _send(http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email, 'hash_senha': hashSenha}),
    ));

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 409) {
      throw Exception('E-mail já cadastrado. Tente fazer login.');
    } else if (response.statusCode == 400) {
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final fieldErrors = data['errors']?['fieldErrors'] as Map<String, dynamic>?;
        if (fieldErrors != null && fieldErrors.isNotEmpty) {
          final firstList = fieldErrors.values.first as List;
          throw Exception(firstList.first as String);
        }
      } on Exception {
        rethrow;
      } catch (_) {}
      throw Exception('Dados inválidos. Verifique os campos.');
    } else {
      throw Exception('Erro ao cadastrar (${response.statusCode}).');
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

    final response = await _send(http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    ));

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Sessão expirada. Faça login novamente.');
    } else {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getUsuario() async {
    if (userId == null || token == null) {
      throw Exception('Usuário não autenticado.');
    }

    final url = Uri.parse('$_baseUrl/usuarios/$userId');
    final response = await _send(http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['data'] as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw Exception('Sessão expirada. Faça login novamente.');
    } else {
      throw Exception('Erro ao buscar dados do usuário (${response.statusCode}).');
    }
  }

  Map<String, String> _authHeaders() {
    if (token == null) {
      throw Exception('Usuário não autenticado.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> salvarExame({
    required int idUsuario,
    required int idade,
    required bool sexo,
    required double pulso,
    required double pressaoSistolica,
    required double pressaoDiastolica,
    required double glicose,
    required double ckMb,
    required double troponina,
    required bool result,
  }) async {
    final url = Uri.parse('$_baseUrl/exames');
    final response = await _send(http.post(
      url,
      headers: _authHeaders(),
      body: jsonEncode({
        'id_usuario': idUsuario,
        'idade': idade,
        'sexo': sexo,
        'pulso': pulso,
        'pressao_sistolica': pressaoSistolica,
        'pressao_diastolica': pressaoDiastolica,
        'glicose': glicose,
        'ck_mb': ckMb,
        'troponina': troponina,
        'result': result,
      }),
    ));

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Sessão expirada. Faça login novamente.');
    } else {
      throw Exception('Erro ao salvar exame (${response.statusCode}).');
    }
  }

  Future<List<Map<String, dynamic>>> listarExames() async {
    final url = Uri.parse('$_baseUrl/exames');
    final response = await _send(http.get(url, headers: _authHeaders()));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['data'] as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 401) {
      throw Exception('Sessão expirada. Faça login novamente.');
    } else {
      throw Exception('Erro ao listar exames (${response.statusCode}).');
    }
  }

  Future<void> deletarExame(int id) async {
    final url = Uri.parse('$_baseUrl/exames/$id');
    final response = await _send(http.delete(url, headers: _authHeaders()));

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Sessão expirada. Faça login novamente.');
    } else if (response.statusCode == 404) {
      throw Exception('Exame não encontrado.');
    } else {
      throw Exception('Erro ao excluir exame (${response.statusCode}).');
    }
  }

  Future<void> atualizarExame(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/exames/$id');
    final response = await _send(http.put(
      url,
      headers: _authHeaders(),
      body: jsonEncode(data),
    ));

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Sessão expirada. Faça login novamente.');
    } else if (response.statusCode == 404) {
      throw Exception('Exame não encontrado.');
    } else {
      throw Exception('Erro ao atualizar exame (${response.statusCode}).');
    }
  }

  Future<Map<String, dynamic>> analisarRiscoAtaqueCardiaco({
    required double age,
    required int gender,
    required double impluse,
    required double pressurehight,
    required double pressurelow,
    required double glucose,
    required double kcm,
    required double troponin,
  }) async {
    final url = Uri.parse('$_baseUrl/diagnosticos/risco');
    final body = <String, dynamic>{
      'age': age,
      'gender': gender,
      'impluse': impluse,
      'pressurehight': pressurehight,
      'pressurelow': pressurelow,
      'glucose': glucose,
      'kcm': kcm,
      'troponin': troponin,
    };

    final response = await _send(http.post(
      url,
      headers: _authHeaders(),
      body: jsonEncode(body),
    ));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return Map<String, dynamic>.from(decoded['data'] ?? decoded);
    } else if (response.statusCode == 401) {
      throw Exception('Sessão expirada. Faça login novamente.');
    } else {
      throw Exception('Erro ao analisar risco (${response.statusCode}): ${response.body}');
    }
  }
}
