// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:chatroom/login.dart';
import 'package:chatroom/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/client.dart';
import 'package:chatroom/homepage.dart';

class ServerConnecitonPage extends StatefulWidget {
  const ServerConnecitonPage({super.key});

  @override
  State<ServerConnecitonPage> createState() => _ServerConnecitonPageState();
}

class _ServerConnecitonPageState extends State<ServerConnecitonPage> {
  @override
  Widget build(BuildContext context) {
    InputForm server = InputForm(label: "Server url:");

    return Scaffold(
        appBar: AppBar(
          title: const Text("Connect to the server"),
        ),
        body: Center(
            child: Column(
          children: [
            const SizedBox(height: 50),
            server,
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () async {
                  bool check = await Client.checkServer(server.value);
                  if (check) {
                    url = server.value;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext c) => LoginPage()));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Server not reachable'),
                            content: const Text(
                                'check the url inserted and try again, remember to use only ip and port ex. localhost:8008'),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  }
                },
                child: const Text("Check"))
          ],
        )));
  }
}
