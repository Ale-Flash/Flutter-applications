// ignore_for_file: non_constant_identifier_names

import 'package:chatroom/structures.dart';
import 'package:chatroom/widgets/input.dart';
import 'package:chatroom/homepage.dart';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => CreateGroupPageState();
}

class CreateGroupPageState extends State<CreateGroupPage> {
  String group_id = "";
  @override
  Widget build(BuildContext context) {
    InputForm name = InputForm(label: "Enter the group name:");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create chat group'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            height: 50,
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "Enter the group id:",
              ),
              onChanged: (val) => group_id = val,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 30),
          name
        ],
      ),
      floatingActionButton: Container(
        alignment: const Alignment(1.05, 1),
        child: ElevatedButton(
            onPressed: () async {
              int? id = int.tryParse(group_id);
              if (id == null || name.value.isEmpty) return;
              if (await chat.existGroup(id)) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Group id already taken'),
                        content: Text(
                            'sorry, but that group id was already taken, try something else :)'),
                      );
                    });
                return;
              }
              if (!await chat.createGroup(Group(id, name.value))) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Unsuccessful'),
                        content:
                            Text('Something went wrong creating the new group'),
                      );
                    });
                return;
              }
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Group created successfully'),
                      content: Text('Congrats! You created a new group'),
                    );
                  });
              chat.requestChats();
            },
            style: ElevatedButton.styleFrom(shape: const CircleBorder()),
            child: const SizedBox(
                width: 50, height: 50, child: Icon(Icons.check_rounded))),
      ),
    );
  }
}
