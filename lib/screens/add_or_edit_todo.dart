import 'package:flutter/material.dart';
import 'package:notes/database_helper/database_helper.dart';
import 'package:notes/model/model.dart';
import 'package:notes/utils/components.dart';

class AddOrEditTodo extends StatefulWidget {
  const AddOrEditTodo({super.key, this.model, this.isEdit = false, required this.isCreate, this.i = false});
  final TodoModel? model;
  final bool isEdit;
  final bool isCreate;
  final bool i;
  @override
  State<AddOrEditTodo> createState() => _AddOrEditTodoState();
}

class _AddOrEditTodoState extends State<AddOrEditTodo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.model != null) _init();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                enabled: widget.isEdit == true || widget.isCreate == true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title cannot be empty";
                  } else {
                    return null;
                  }
                },
                controller: _titleController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),
              Components.sizedBoxHeight(15),
              TextFormField(
                enabled: widget.isEdit == true || widget.isCreate == true,
                maxLines: 6,
                controller: _descriptionController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),
              Components.sizedBoxHeight(30),
              if (widget.isEdit == true || widget.isCreate == true)
                ShrinkingButton(
                  buttonColor: Colors.blueGrey.shade700,
                  text: widget.model != null ? "Update Note" : "Create Note",
                  textSize: 18,
                  onTap: () async {
                    if (widget.model != null) {
                      await TodoDatabase.instance
                          .updateTodo(
                            TodoModel(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              isImportant: false,
                              createdTime: DateTime.now(),
                            ),
                          )
                          .then((value) => Navigator.of(context).pop(true));
                    } else {
                      if (_formKey.currentState!.validate()) {
                        await TodoDatabase.instance
                            .createTodo(
                              TodoModel(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                isImportant: false,
                                createdTime: DateTime.now(),
                              ),
                            )
                            .then((value) => Navigator.of(context).pop(true));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill the title"),
                          ),
                        );
                      }
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
        icon: const Icon(
          Icons.arrow_back_outlined,
          color: Colors.white,
        ),
      ),
      actions: (widget.i == true)
          ? [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddOrEditTodo(
                        isCreate: false,
                        isEdit: true,
                        model: widget.model,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
              Components.sizedBoxWidth(8),
              IconButton(
                onPressed: () async {
                  await TodoDatabase.instance
                      .delete(widget.model!.id!)
                      .then((value) => Navigator.of(context).pop(true));
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              Components.sizedBoxWidth(8),
            ]
          : [],
    );
  }

  _init() {
    _titleController.text = widget.model!.title;
    _descriptionController.text = widget.model!.description;
  }
}
