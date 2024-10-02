import 'package:flutter/material.dart'; // fornece ferramentas de interface
import 'package:provider/provider.dart'; // para gerenciar estado

//notificar os "ouvintes" sobre mudanças de estado
class ProvedorLista with ChangeNotifier {
  List<String> _tarefas = []; // lista de tarefas

  List<String> get tarefas => _tarefas; // retorna a lista de tarefas

  void adicionarTarefa(String tarefa) {
    _tarefas.add(tarefa); 
    notifyListeners(); 
  }

  void removerTarefa(int index) {
    _tarefas.removeAt(index); 
    notifyListeners(); 
  }
}

//define a classe do app como um todo
class ToDoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( // provedor com uma instância pra acessar em todos os widgets
      create: (_) => ProvedorLista(),
      child: MaterialApp( // aparência básica do app definida por isso
        home: TelaToDoList(), // define a tela principal
      ),
    );
  }
}

class TelaToDoList extends StatelessWidget {
  final TextEditingController _controller = TextEditingController(); // controlador para o campo de entrada

  @override
  Widget build(BuildContext context) {
    final provedorLista = Provider.of<ProvedorLista>(context);
    return Scaffold( // estrutura básica e barra de navegação
      appBar: AppBar( // barra de navegação
        title: Text('To Do List'),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 3, 146, 103),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: provedorLista.tarefas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(provedorLista.tarefas[index]), 
                    trailing: IconButton(
                      icon: Icon(Icons.delete), 
                      onPressed: () => provedorLista.removerTarefa(index), 
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // adiciona espaçamento
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller, // associa o controlador ao campo de entrada
                      decoration: InputDecoration(
                        labelText: 'Adicionar Tarefa',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add), 
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        provedorLista.adicionarTarefa(_controller.text); 
                        _controller.clear(); 
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(ToDoListApp());
}
