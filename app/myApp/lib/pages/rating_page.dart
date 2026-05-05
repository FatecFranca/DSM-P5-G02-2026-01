import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final _formKey = GlobalKey<FormState>();

  // Campos do formulário
  String? _tipo;
  String? _faixaPreco;
  String? _ambiente;
  String? _publico;
  double _avaliacao = 0;
  TimeOfDay? _abre;
  TimeOfDay? _fecha;
  bool _isLoading = false;

  final List<String> _tiposEstabelecimento = [
    'bar',
    'hamburgueria',
    'lanchonete',
    'restaurante',
    'cafeteria',
    'pizzaria',
    'churrascaria',
    'sushi bar',
    'choperia',
    'espetaria',
    'bar/hamburgueria',
  ];

  final List<String> _faixasPreco = [
    'barato',
    'medio',
    'caro',
  ];

  final List<String> _ambientes = [
    'formal',
    'informal',
  ];

  final List<String> _publicosAlvo = [
    'jovem',
    'adulto',
    'jovem/adulto',
  ];

  Future<void> _selectTime(bool isAbre) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isAbre
          ? (_abre ?? const TimeOfDay(hour: 8, minute: 0))
          : (_fecha ?? const TimeOfDay(hour: 22, minute: 0)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppTheme.secondary,
              hourMinuteColor: AppTheme.inputFill,
              hourMinuteTextColor: AppTheme.textPrimary,
              dayPeriodColor: AppTheme.inputFill,
              dayPeriodTextColor: AppTheme.textPrimary,
              dialBackgroundColor: AppTheme.inputFill,
              dialHandColor: AppTheme.accent,
              dialTextColor: AppTheme.textPrimary,
              entryModeIconColor: AppTheme.accent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isAbre) {
          _abre = picked;
        } else {
          _fecha = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Selecionar horário';
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_avaliacao == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, dê uma avaliação'),
          backgroundColor: AppTheme.accent,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Avaliação enviada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go(AppRouter.ratingHistory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Avaliação')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle('Informações do Local'),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Tipo de estabelecimento',
                  value: _tipo,
                  items: _tiposEstabelecimento,
                  icon: Icons.store_outlined,
                  onChanged: (val) => setState(() => _tipo = val),
                  validator: (val) => val == null ? 'Selecione o tipo' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Faixa de preço',
                  value: _faixaPreco,
                  items: _faixasPreco,
                  icon: Icons.attach_money_rounded,
                  onChanged: (val) => setState(() => _faixaPreco = val),
                  validator: (val) => val == null ? 'Selecione a faixa de preço' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Ambiente',
                  value: _ambiente,
                  items: _ambientes,
                  icon: Icons.chair_outlined,
                  onChanged: (val) => setState(() => _ambiente = val),
                  validator: (val) => val == null ? 'Selecione o ambiente' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Público-alvo',
                  value: _publico,
                  items: _publicosAlvo,
                  icon: Icons.groups_outlined,
                  onChanged: (val) => setState(() => _publico = val),
                  validator: (val) => val == null ? 'Selecione o público-alvo' : null,
                ),
                const SizedBox(height: 28),
                _buildSectionTitle('Sua Avaliação'),
                const SizedBox(height: 16),
                _buildStarRating(),
                const SizedBox(height: 28),
                _buildSectionTitle('Funcionamento'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker(
                        label: 'Abre às',
                        time: _abre,
                        icon: Icons.schedule_outlined,
                        onTap: () => _selectTime(true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTimePicker(
                        label: 'Fecha às',
                        time: _fecha,
                        icon: Icons.schedule_rounded,
                        onTap: () => _selectTime(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleSubmit,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(_isLoading ? 'Enviando...' : 'Enviar Avaliação'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, 1),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      style: const TextStyle(color: AppTheme.textPrimary),
      dropdownColor: AppTheme.secondary,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildStarRating() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _avaliacao > 0
              ? AppTheme.accent.withOpacity(0.4)
              : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Text(
            _avaliacao == 0
                ? 'Toque para avaliar'
                : _getAvaliacaoLabel(_avaliacao),
            style: TextStyle(
              color: _avaliacao > 0 ? AppTheme.accent : AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = (index + 1).toDouble();
              return GestureDetector(
                onTap: () => setState(() => _avaliacao = starValue),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    index < _avaliacao ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: index < _avaliacao ? Colors.amber : AppTheme.textSecondary,
                    size: 40,
                  ),
                ),
              );
            }),
          ),
          if (_avaliacao > 0) ...[
            const SizedBox(height: 8),
            Text(
              '$_avaliacao / 5',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getAvaliacaoLabel(double avaliacao) {
    switch (avaliacao.toInt()) {
      case 1:
        return 'Péssimo 😞';
      case 2:
        return 'Ruim 😕';
      case 3:
        return 'Regular 😐';
      case 4:
        return 'Bom 😊';
      case 5:
        return 'Excelente! 🤩';
      default:
        return '';
    }
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final hasValue = time != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasValue ? AppTheme.accent.withOpacity(0.4) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: hasValue ? AppTheme.accent : AppTheme.textSecondary,
                size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    _formatTime(time),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: hasValue ? AppTheme.textPrimary : AppTheme.textSecondary,
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    return NavigationBar(
      backgroundColor: AppTheme.secondary,
      indicatorColor: AppTheme.accent.withOpacity(0.2),
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go(AppRouter.dashboard);
            break;
          case 1:
            context.go(AppRouter.rating);
            break;
          case 2:
            context.go(AppRouter.ratingHistory);
            break;
          case 3:
            context.go(AppRouter.user);
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded, color: AppTheme.accent),
          label: 'Início',
        ),
        NavigationDestination(
          icon: Icon(Icons.star_outline_rounded),
          selectedIcon: Icon(Icons.star_rounded, color: AppTheme.accent),
          label: 'Avaliar',
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
}