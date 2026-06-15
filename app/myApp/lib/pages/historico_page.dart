import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../services/api.dart';
import '../theme/app_theme.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final _api = ApiService();
  List<Map<String, dynamic>> _exames = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _carregarExames();
  }

  Future<void> _carregarExames() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final todos = await _api.listarExames();
      final userId = ApiService.userId;
      final filtrados = todos.where((e) => e['id_usuario'] == userId).toList();
      filtrados.sort((a, b) {
        final da = DateTime.tryParse(a['created_at'] as String? ?? '') ?? DateTime(0);
        final db = DateTime.tryParse(b['created_at'] as String? ?? '') ?? DateTime(0);
        return db.compareTo(da);
      });
      if (mounted) {
        setState(() {
          _exames = filtrados;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _loading = false;
        });
      }
    }
  }

  Future<void> _confirmarDeletar(Map<String, dynamic> exame) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir exame'),
        content: const Text('Deseja realmente excluir este exame? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _api.deletarExame(exame['id_exame'] as int);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 8),
            Text('Exame excluído com sucesso.'),
          ]),
          backgroundColor: Colors.green,
        ),
      );
      _carregarExames();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _abrirEdicao(Map<String, dynamic> exame) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditarExameSheet(
        exame: exame,
        onSaved: () {
          Navigator.of(ctx).pop();
          _carregarExames();
        },
      ),
    );
  }

  String _formatarData(String? iso) {
    if (iso == null) return '-';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '-';
    final l = dt.toLocal();
    return '${l.day.toString().padLeft(2, '0')}/'
        '${l.month.toString().padLeft(2, '0')}/'
        '${l.year}  '
        '${l.hour.toString().padLeft(2, '0')}:'
        '${l.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: _carregarExames,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.background,
        indicatorColor: AppTheme.accent.withValues(alpha: 0.2),
        selectedIndex: 1,
        onDestinationSelected: (index) {
          if (index == 0) context.go(AppRouter.exames);
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
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _carregarExames,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }
    if (_exames.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 48, color: AppTheme.textSecondary),
            SizedBox(height: 12),
            Text('Nenhum exame salvo ainda.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _carregarExames,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _exames.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) => _exameCard(_exames[i]),
      ),
    );
  }

  Widget _exameCard(Map<String, dynamic> exame) {
    final result = (exame['result'] as bool?) ?? false;
    final data = _formatarData(exame['created_at'] as String?);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (result ? Colors.redAccent : Colors.green).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                result ? Icons.warning_rounded : Icons.check_circle_rounded,
                color: result ? Colors.redAccent : Colors.green,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result ? 'Alto risco' : 'Baixo risco',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: result ? Colors.redAccent : Colors.green,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(data,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              color: AppTheme.accent,
              tooltip: 'Editar',
              onPressed: () => _abrirEdicao(exame),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: Colors.redAccent,
              tooltip: 'Excluir',
              onPressed: () => _confirmarDeletar(exame),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditarExameSheet extends StatefulWidget {
  final Map<String, dynamic> exame;
  final VoidCallback onSaved;

  const _EditarExameSheet({required this.exame, required this.onSaved});

  @override
  State<_EditarExameSheet> createState() => _EditarExameSheetState();
}

class _EditarExameSheetState extends State<_EditarExameSheet> {
  final _api = ApiService();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idade;
  late final TextEditingController _pulso;
  late final TextEditingController _sistolica;
  late final TextEditingController _diastolica;
  late final TextEditingController _glicose;
  late final TextEditingController _ckMb;
  late final TextEditingController _troponina;
  late int _sexo;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final e = widget.exame;
    _idade = TextEditingController(text: e['idade']?.toString() ?? '');
    _pulso = TextEditingController(text: e['pulso']?.toString() ?? '');
    _sistolica = TextEditingController(text: e['pressao_sistolica']?.toString() ?? '');
    _diastolica = TextEditingController(text: e['pressao_diastolica']?.toString() ?? '');
    _glicose = TextEditingController(text: e['glicose']?.toString() ?? '');
    _ckMb = TextEditingController(text: e['ck_mb']?.toString() ?? '');
    _troponina = TextEditingController(text: e['troponina']?.toString() ?? '');
    _sexo = (e['sexo'] as bool?) == true ? 1 : 0;
  }

  @override
  void dispose() {
    _idade.dispose();
    _pulso.dispose();
    _sistolica.dispose();
    _diastolica.dispose();
    _glicose.dispose();
    _ckMb.dispose();
    _troponina.dispose();
    super.dispose();
  }

  String? _validateNumber(String? v) {
    if (v == null || v.trim().isEmpty) return 'Obrigatório';
    if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Número inválido';
    return null;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      await _api.atualizarExame(widget.exame['id_exame'] as int, {
        'idade': int.parse(_idade.text),
        'sexo': _sexo == 1,
        'pulso': double.parse(_pulso.text.replaceAll(',', '.')),
        'pressao_sistolica': double.parse(_sistolica.text.replaceAll(',', '.')),
        'pressao_diastolica': double.parse(_diastolica.text.replaceAll(',', '.')),
        'glicose': double.parse(_glicose.text.replaceAll(',', '.')),
        'ck_mb': double.parse(_ckMb.text.replaceAll(',', '.')),
        'troponina': double.parse(_troponina.text.replaceAll(',', '.')),
      });
      widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _salvando = false);
    }
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(labelText: label),
        validator: _validateNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Editar exame',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _field('Idade', _idade),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text('Sexo:',
                      style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16)),
                ),
                RadioGroup<int>(
                  groupValue: _sexo,
                  onChanged: (v) => setState(() => _sexo = v!),
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
                _field('Pulso', _pulso),
                _field('Pressão sistólica', _sistolica),
                _field('Pressão diastólica', _diastolica),
                _field('Glicose', _glicose),
                _field('CK-MB', _ckMb),
                _field('Troponina', _troponina),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _salvando ? null : _salvar,
                    child: _salvando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Salvar alterações'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
