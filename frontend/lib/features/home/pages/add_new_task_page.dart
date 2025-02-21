import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/home/cubit/tasks_cubit.dart';
import 'package:intl/intl.dart';

class AddNewTaskPage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) => const AddNewTaskPage(),
      );

  const AddNewTaskPage({super.key});

  @override
  State<AddNewTaskPage> createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Color selectedColor = Color.fromRGBO(246, 222, 194, 1);
  final formKey = GlobalKey<FormState>();

  @Deprecated('Use .r.')
  void createNewTask() async {
    if (formKey.currentState!.validate()) {
      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
      await context.read<TasksCubit>().createNewTask(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          color: selectedColor,
          token: user.user.token,
          dueAt: selectedDate);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // @Deprecated('Use .r.')
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Task'),
          actions: [
            GestureDetector(
              onTap: () async {
                final _selectedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 90),
                  ),
                );
                
                if (_selectedDate != null) {
                  setState(() {
                    selectedDate = _selectedDate;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat("MM-d-y").format(selectedDate),
                ),
              ),
            )
          ],
        ),
        body: BlocConsumer<TasksCubit, TasksState>(
          listener: (context, state) {
            if(state is TasksError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Task added successfully"))
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Title can not be Empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description',
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 10),
                    ColorPicker(
                      heading: const Text('Select Color'),
                      subheading: const Text('Select a different shade'),
                      onColorChanged: (Color color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      color: selectedColor,
                      pickersEnabled: const {ColorPickerType.wheel: true},
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: createNewTask,
                        child: const Text('Submit',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)))
                  ],
                ),
              ),
            );
          },
        ),);
  }
}
