import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final todo = widget.todo!;
      titleController.text = todo['title'];
      descriptionController.text = todo['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit? "Edit QMT ToDo" : "Add QMT ToDo"
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: "Enter Title",
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: "Enter Description",
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5, 
            maxLines: 10,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? "Update" : "Submit"
              )
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo!;
    if (todo == null) {
      print("Todo is null");
      return;
    }
    final id = todo['id'];
    final is_completed = todo['is_completed'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": is_completed,
    };
    final url = "http://192.168.1.12:8000/v1/todos/update/$id/";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      print('Data saved successfully');
      print(response.body);
      showSuccessMessage('Data updated successfully');
    } 
    else {
      print('Failed to save data. Status code: ${response.statusCode}');
      showErrorMessage('Failed to update data. Status code: ${response.statusCode}');
    }
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    const url = "http://192.168.1.12:8000/v1/todos/create/";
    final uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json', 
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print('Data saved successfully');
        print(response.body);
        showSuccessMessage('Data saved successfully');
      } 
      else {
        print('Failed to save data. Status code: ${response.statusCode}');
        showErrorMessage('Failed to save data. Status code: ${response.statusCode}');
      }
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