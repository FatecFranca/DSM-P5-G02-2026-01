import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../services/api.dart';
import '../theme/app_theme.dart';

class ExamePage extends StatefulWidget {
  const ExamePage({super.key});

  @override
  State<ExamePage> createState() => _ExamePageState();
}

class _ExamePageState extends State<ExamePage> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();

  final _age = TextEditingController();
  int? _selectedGender;
  final _impluse = TextEditingController();
  final _pressurehight = TextEditingController();
  final _pressurelow = TextEditingController();
  final _glucose = TextEditingController();
  final _kcm = TextEditingController();
  final _troponin = TextEditingController();

  bool _loading = false;
  Map<String, dynamic>? _resultado;

  @override
  void dispose() {
    _age.dispose();
    _impluse.dispose();
    _pressurehight.dispose();
    _pressurelow.dispose();
    _glucose.dispose();
    _kcm.dispose();
    _troponin.dispose();
    super.dispose();
  }

  String? _requiredNumber(String? value, {bool isGender = false}) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) return 'Informe um número válido';
    if (isGender && !(parsed == 0 || parsed == 1)) return 'Use 0 ou 1';
    return null;
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma opção para o Sexo (0 ou 1).'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final data = await _api.analisarRiscoAtaqueCardiaco(
        age: double.parse(_age.text.replaceAll(',', '.')),
        gender: _selectedGender!,  
        impluse: double.parse(_impluse.text.replaceAll(',', '.')),
        pressurehight: double.parse(_pressurehight.text.replaceAll(',', '.')),
        pressurelow: double.parse(_pressurelow.text.replaceAll(',', '.')),
        glucose: double.parse(_glucose.text.replaceAll(',', '.')),
        kcm: double.parse(_kcm.text.replaceAll(',', '.')),
        troponin: double.parse(_troponin.text.replaceAll(',', '.')),
      );

      if (!mounted) return;
      setState(() => _resultado = data);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risco de Ataque Cardíaco'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () {
              ApiService.logout();
              context.go(AppRouter.login);
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Preencha os dados de exame abaixo para análise inicial de risco.',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 16),
                _field('Idade (age)', _age),
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 4),
                  child: Text(
                    'Sexo (gender):',
                    style: TextStyle(
                      color: AppTheme.textPrimary, 
                      fontSize: 16, 
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<int>(
                        title: const Text('0 (Feminino)'),
                        value: 0,
                        groupValue: _selectedGender,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<int>(
                        title: const Text('1 (Masculino)'),
                        value: 1,
                        groupValue: _selectedGender,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _field('Pulso (impluse)', _impluse),
                _field('Pressão sistólica (pressurehight)', _pressurehight),
                _field('Pressão diastólica (pressurelow)', _pressurelow),
                _field('Glicose (glucose)', _glucose),
                _field('CK-MB (kcm)', _kcm),
                _field('Troponina (troponin)', _troponin),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _enviar,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.monitor_heart_rounded),
                    label: Text(_loading ? 'Analisando...' : 'Analisar risco'),
                  ),
                ),
                const SizedBox(height: 18),
                if (_resultado != null) _resultadoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {bool isGender = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(labelText: label),
        validator: (value) => _requiredNumber(value, isGender: isGender),
      ),
    );
  }

  Widget _resultadoCard() {
    final temChance = (_resultado!['tem_chance'] as bool?) ?? false;
    final chance = (_resultado!['chance_percentual'] ?? 0).toString();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: temChance ? Colors.redAccent : Colors.greenAccent,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            temChance ? 'Há chance de ataque cardíaco' : 'Baixa chance de ataque cardíaco',
            style: TextStyle(
              color: temChance ? Colors.redAccent : Colors.greenAccent,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Probabilidade estimada: $chance%',
            style: const TextStyle(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Resultado preliminar baseado na base tratada. Não substitui avaliação médica.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
