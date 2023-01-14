// ignore_for_file:

import 'package:chatroom/structures.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/homepage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

String? value;
List<Group> results = [];

class _SearchPageState extends State<SearchPage> {
  void search() async {
    if (value == null || value!.isEmpty) return;
    if (value![0] == '@') {
      if (int.tryParse(value!.substring(1)) == null) return;
      Group? g = await chat.getGroup(int.parse(value!.substring(1)));
      if (g == null) return;
      results = [g];
    } else {
      results = await chat.getGroups(value!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              height: 50,
              child: TextFormField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: const OutlineInputBorder(),
                    hintText: 'Search group: @id or name',
                    suffixIcon: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue),
                      child: ElevatedButton(
                        onPressed: search,
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white),
                      ),
                    )),
                onChanged: (val) => value = val,
              ),
            ),
            results.isEmpty
                ? const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 100),
                    child: Text("No results...", style: textStyle),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (_, index) => GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Join group'),
                                      content: RichText(
                                        text: TextSpan(
                                          style: textStyle,
                                          children: <TextSpan>[
                                            const TextSpan(
                                                text:
                                                    'Would you like to join '),
                                            TextSpan(
                                                text: results[index].name,
                                                style: textStyleBold),
                                            const TextSpan(text: '?')
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: const Text('YES'),
                                          onPressed: () {
                                            chat.joinGroup(results[index].id);
                                            asked = false;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: const Text('NO'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    // color: Colors.amber,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                height: 50,
                                child: Row(
                                  children: [
                                    Text("  @${results[index].id} ",
                                        style: textStyle),
                                    Text(results[index].name,
                                        style: textStyleBold)
                                  ],
                                )))),
                  )
          ]),
    );
  }
}
