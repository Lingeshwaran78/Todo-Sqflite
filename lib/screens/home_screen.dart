import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_sqflite/database_helper/database_helper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo_sqflite/screens/add_or_edit_todo.dart';
import 'package:todo_sqflite/utils/card_widget.dart';
import '../model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<TodoModel> list;
  bool isLoading = false;
  @override
  void initState() {
    _getTodos();
    super.initState();
  }

  @override
  void dispose() {
    closing();
    super.dispose();
  }

  Future _getTodos() async {
    setState(() => isLoading = true);
    list = await TodoDatabase.instance.readAllTodo();
    setState(() => isLoading = false);
    debugPrint(list.length.toString());
  }

  Future closing() async {
    await TodoDatabase.instance.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: isLoading
          ? Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Lottie.asset("assets/hamster.json"),
              ),
            )
          : list.isEmpty
              ? Center(
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Lottie.asset("assets/empty_list.json"),
                  ),
                )
              : _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.blueGrey,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () async {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const AddOrEditTodo(
                isCreate: true,
              );
            },
          ),
        );
        if (result != null) _getTodos();
      },
    );
  }

  _buildBody() {
    return MasonryGridView.builder(
      itemCount: list.length,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2),
      itemBuilder: (context, index) {
        return GridTile(
            child: NoteCardWidget(
          onTap: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddOrEditTodo(
                  model: list[index],
                  isCreate: false,
                  i: true,
                ),
              ),
            );
            if (result != null) _getTodos();
          },
          model: list[index],
          index: index,
        ));
      },
    );
  }
}
