// ignore_for_file: , use_build_context_synchronously, prefer_const_constructors

import 'package:chatroom/homepage.dart';
import 'package:chatroom/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/widgets/password.dart';
import 'package:chatroom/client.dart';
import 'package:chatroom/structures.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool signin = true;

  @override
  Widget build(BuildContext context) {
    FormFieldSample password = FormFieldSample();
    InputForm id = InputForm(label: "Enter your id:");
    InputForm name = InputForm(label: "Enter your name:");
    InputForm surname = InputForm(label: "Enter your surname:");

    return Scaffold(
        appBar: AppBar(
          title: const Text("Authorize user"),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            id,
            (signin ? const SizedBox() : name),
            (signin ? const SizedBox() : surname),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                height: 150,
                child: password),
            (signin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            // finished
                            signin = false;
                            setState(() {});
                          },
                          child: const Text("Sign up")),
                      ElevatedButton(
                          onPressed: () async {
                            User? u;
                            if (id.value.isNotEmpty &&
                                password.password.isNotEmpty) {
                              u = await Client.getUser(
                                  id.value, password.password, url);
                              if (u != null) {
                                user = u;
                                chat = Client(user, url);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext c) =>
                                            HomePage()));
                              }
                            }
                          },
                          child: const Text("Log in"))
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            // finish
                            signin = true;
                            setState(() {});
                          },
                          child: const Icon(Icons.arrow_back_rounded)),
                      ElevatedButton(
                          onPressed: () async {
                            if (id.value.isNotEmpty &&
                                name.value.isNotEmpty &&
                                surname.value.isNotEmpty &&
                                password.password.isNotEmpty) {
                              User u = User(id.value, name.value, surname.value,
                                  password.password);
                              bool result = await Client.createUser(u, url);
                              if (result) {
                                user = u;
                                chat = Client(user, url);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext c) =>
                                            HomePage()));
                              }
                            }
                          },
                          child: const Text("Create user"))
                    ],
                  )),
          ],
        )));
  }
}
