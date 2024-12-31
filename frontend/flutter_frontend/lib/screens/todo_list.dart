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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   fetchTodo();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo QMT App"),
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
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item['title'] ?? 'No Title'),
                subtitle: Text(item['description'] ?? 'No Description'),
                // trailing: Icon(
                //   item['is_completed'] == true ? Icons.check_circle : Icons.cancel,
                //   color: item['is_completed'] == true ? Colors.green : Colors.red,
                // )
                trailing: PopupMenuButton(
                  onSelected: (value){
                    if(value == 'edit'){
                      // navigate to edit page
                    }else if(value == 'delete'){
                      // delete item
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

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    Navigator.push(context, route);
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

}