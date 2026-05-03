import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListState();
}

class _ListState extends State<ListScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _ambienteController = TextEditingController();
  final TextEditingController _publicoController = TextEditingController();
  final TextEditingController _avaliacaoController = TextEditingController();
  final TextEditingController _abreController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  List<String> tarefas = [];

  Widget textField(String label,
      {TextEditingController? controller,
      String? placeholder,
      IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: icon != null
                    ? Icon(icon, color: Colors.grey.shade400)
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: 16,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
        child: Column(
          children: [
            textField(
              'Nome',
              controller: _nomeController,
              placeholder: 'Ex: Eduardo Batista Matos',
              icon: Icons.person,
            ),
            textField(
              'Local',
              controller: _localController,
              placeholder: 'Ex: São Paulo',
              icon: Icons.location_on,
            ),
            textField(
              'Tipo',
              controller: _tipoController,
              placeholder: 'Ex: Restaurante',
              icon: Icons.restaurant,
            ),
            textField(
              'Faixa de preço',
              controller: _precoController,
              placeholder: 'Ex: R\$ 50 - R\$ 100',
              icon: Icons.attach_money,
            ),
            textField(
              'Ambiente',
              controller: _ambienteController,
              placeholder: 'Ex: Casual',
              icon: Icons.chair,
            ),
            textField(
              'Público',
              controller: _publicoController,
              placeholder: 'Ex: Família',
              icon: Icons.group,
            ),
            textField(
              'Avaliação',
              controller: _avaliacaoController,
              placeholder: 'Ex: 4.5',
              icon: Icons.star_border,
            ),
            textField(
              'Abre',
              controller: _abreController,
              placeholder: 'Ex: 08:00',
              icon: Icons.access_time,
            ),
            textField(
              'Fecha',
              controller: _fechaController,
              placeholder: 'Ex: 22:00',
              icon: Icons.access_time_filled,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_nomeController.text.isNotEmpty) {
                      tarefas.add(_nomeController.text);
                      _nomeController.clear();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[600],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tarefas.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(tarefas[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}