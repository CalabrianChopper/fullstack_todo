import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo QMT App"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Visibility(
        visible: !isLoading,
        replacement: const Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context,index){
              final item = items[index];
              final id = item['id'].toString();
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item['title'] ?? 'No Title'),
                subtitle: Text(item['description'] ?? 'No Description'),
                trailing: PopupMenuButton(
                  onSelected: (value){
                    if(value == 'edit'){
                      // navigate to edit page
                      navigateToEditPage(item);
                    }else if(value == 'delete'){
                      // delete item
                      deleteById(id);
                    }
                  },
                  itemBuilder: (context){
                    return [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit')
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete')
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text("Add ToDo"),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo:item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final url = "http://192.168.1.12:8000/v1/todos/delete/$id/";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if(response.statusCode == 204){
      final filtered = items.where((item) => item['id'] != id).toList();
      setState((){
        items = filtered;
      });
      showSuccessMessage('Todo deleted successfully');
      fetchTodo();
    }
    else{
      print('Failed to delete item with id: $id and status code: ${response.statusCode}');
      showErrorMessage('Failed to delete item with id: $id');
    }
  }

  Future<void> fetchTodo() async {
    print('fetchTodo called'); 
    try {

      const url = "http://192.168.1.12:8000/v1/todos/";
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      print('Response status code: ${response.statusCode}'); 
      print('Response body: ${response.body}'); 

      if (response.statusCode == 200) {
        print('Success with status code: ${response.statusCode}');
        print('Data: ${response.body}');
        final json = jsonDecode(response.body) as List;
        setState(() {
          items = json;
        });
      } else {
        print('Failed with status: ${response.statusCode}');
      }
      setState(() {
        isLoading = false;
      });
    } 
    catch (e) {
      print('Error: $e'); 
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}