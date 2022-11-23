import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tododatabase/data/database.dart';
import 'package:tododatabase/until/todo_tile.dart';

import '../constants/colors.dart';
import '../until/dialog_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  TodoDatabase db = TodoDatabase();
  final _controller = TextEditingController();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateData();
  }

  void saveNewTask() {
    setState(() {
      db.todoList.add([_controller.text, false]);
    });
    Navigator.of(context).pop();
    db.updateData();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text('ToDo',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35),),
              Container(
                height: 40,
                color: Colors.blue,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('images/avatar.jpg'),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
            itemCount: db.todoList.length,
            itemBuilder: (context, index) {
              return TodoTile(
                taskName: db.todoList[index][0],
                taskCompleted: db.todoList[index][1],
                onChanged: (value) => checkBoxChanged(value, index),
                deleteFunction: (context) => deleteTask(index),
              );
            }));
  }
}
