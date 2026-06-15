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
      _mostrarModalResultado(data);
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

  void _limparFormulario() {
    _age.clear();
    _impluse.clear();
    _pressurehight.clear();
    _pressurelow.clear();
    _glucose.clear();
    _kcm.clear();
    _troponin.clear();
    setState(() => _selectedGender = null);
  }

  void _mostrarModalResultado(Map<String, dynamic> data) {
    final temChance = (data['tem_chance'] as bool?) ?? false;
    final chance = (data['chance_percentual'] ?? 0).toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        bool salvando = false;
        return StatefulBuilder(
          builder: (_, setModalState) {
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 48, left: 20, right: 20),
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: AppTheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          temChance ? Icons.warning_rounded : Icons.check_circle_rounded,
                          color: temChance ? Colors.redAccent : Colors.green,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          temChance
                              ? 'Há chance de ataque cardíaco'
                              : 'Baixa chance de ataque cardíaco',
                          style: TextStyle(
                            color: temChance ? Colors.redAccent : Colors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        
                        const SizedBox(height: 4),
                        const Text(
                          'Resultado preliminar. Não substitui avaliação médica.',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: salvando ? null : () => Navigator.of(dialogCtx).pop(),
                                child: const Text('Não salvar'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: salvando
                                    ? null
                                    : () async {
                                        setModalState(() => salvando = true);
                                        try {
                                          await _api.salvarExame(
                                            idUsuario: ApiService.userId!,
                                            idade: int.parse(_age.text),
                                            sexo: _selectedGender == 1,
                                            pulso: double.parse(_impluse.text.replaceAll(',', '.')),
                                            pressaoSistolica: double.parse(_pressurehight.text.replaceAll(',', '.')),
                                            pressaoDiastolica: double.parse(_pressurelow.text.replaceAll(',', '.')),
                                            glicose: double.parse(_glucose.text.replaceAll(',', '.')),
                                            ckMb: double.parse(_kcm.text.replaceAll(',', '.')),
                                            troponina: double.parse(_troponin.text.replaceAll(',', '.')),
                                            result: temChance,
                                          );
                                          if (!dialogCtx.mounted) return;
                                          Navigator.of(dialogCtx).pop();
                                          if (!mounted) return;
                                          _limparFormulario();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(Icons.check, color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Text('Exame salvo com sucesso!'),
                                                ],
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } catch (e) {
                                          setModalState(() => salvando = false);
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString().replaceFirst('Exception: ', '')),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                child: salvando
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Salvar'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risco de Ataque Cardíaco'),
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
                RadioGroup<int>(
                  groupValue: _selectedGender,
                  onChanged: (value) => setState(() => _selectedGender = value),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<int>(
                          title: const Text('0 (Feminino)'),
                          value: 0,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<int>(
                          title: const Text('1 (Masculino)'),
                          value: 1,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return NavigationBar(
      backgroundColor: AppTheme.background,
      indicatorColor: AppTheme.accent.withValues(alpha: 0.2),
      selectedIndex: 0,
      onDestinationSelected: (index) {
        if (index == 1) context.go(AppRouter.historico);
        if (index == 2) context.go(AppRouter.user);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.monitor_heart_outlined),
          selectedIcon: Icon(Icons.monitor_heart_rounded, color: AppTheme.accent),
          label: 'Exame',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history_rounded, color: AppTheme.accent),
          label: 'Histórico',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded, color: AppTheme.accent),
          label: 'Perfil',
        ),
      ],
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

}
