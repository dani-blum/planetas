import 'package:flutter/material.dart';
import 'package:myapp/modelo/planeta.dart';
import 'package:myapp/controles/controle_planeta.dart';
import 'package:myapp/telas/tela_editar.dart';
import 'package:myapp/telas/tela_detalhes.dart';

class TelaListaPlanetas extends StatefulWidget {
  @override
  _TelaListaPlanetasState createState() => _TelaListaPlanetasState();
}

class _TelaListaPlanetasState extends State<TelaListaPlanetas> {
  List<Planeta> _planetas = []; // Lista para armazenar os planetas cadastrados
  bool _isLoading = true; // Indicador de carregamento

  @override
  void initState() {
    super.initState();
    _carregarPlanetas(); // Carrega os planetas ao iniciar a tela
  }

  // Método para buscar todos os planetas no banco de dados
  Future<void> _carregarPlanetas() async {
    final planetas = await PlanetaDatabase.instance.readAllPlanetas();
    setState(() {
      _planetas = planetas;
      _isLoading = false; // Finaliza o carregamento
    });
  }

  // Método para exibir um diálogo de confirmação antes da exclusão
  Future<void> _confirmarRemocao(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir este planeta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancela a exclusão
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removerPlaneta(id); // Confirma a exclusão
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Método para remover um planeta do banco de dados
  Future<void> _removerPlaneta(int id) async {
    await PlanetaDatabase.instance.deletePlaneta(id);
    _carregarPlanetas(); // Atualiza a lista após exclusão
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Planetas')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Exibe indicador de carregamento
          : _planetas.isEmpty
              ? Center(child: Text('Nenhum planeta cadastrado.')) // Mensagem caso a lista esteja vazia
              : ListView.builder(
                  itemCount: _planetas.length,
                  itemBuilder: (context, index) {
                    final planeta = _planetas[index];
                    return ListTile(
                      title: Text(planeta.nome), // Exibe o nome do planeta
                      subtitle: Text(planeta.apelido ?? ''), // Exibe o apelido, se existir
                      onTap: () {
                        // Navega para a tela de detalhes ao tocar no item
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaDetalhesPlaneta(planeta: planeta),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botão para editar o planeta
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final atualizado = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TelaEditarPlaneta(planeta: planeta),
                                ),
                              );
                              if (atualizado == true) {
                                _carregarPlanetas(); // Atualiza a lista ao voltar da edição
                              }
                            },
                          ),
                          // Botão para remover o planeta
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmarRemocao(planeta.id!),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
