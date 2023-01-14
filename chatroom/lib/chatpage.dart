import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chatroom/homepage.dart';
import 'package:chatroom/structures.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  int start = 0;
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  bool askedMessages = false;
  String currentText = "";
  Message? lastMessage;
  TextEditingController tec = TextEditingController();
  void sendMessage() {
    if (currentText.isEmpty) return;
    chat.send(currentText.trim());
    tec.value = const TextEditingValue(text: "");
  }

  @override
  Widget build(BuildContext context) {
    ontxts.listen((data) {
      if (data.isEmpty) return;
      if (data[0].group != group.id) return;
      if (start == 0) {
        messages = List.from(data.reversed);
      } else {
        if (messages[0].toString() == data[data.length - 1].toString()) return;
        messages.insertAll(0, List.from(data.reversed));
      }
      if (messages.isNotEmpty) {
        if (ModalRoute.of(context) != null &&
            ModalRoute.of(context)!.isCurrent) {
          setState(() {});
          if (start == 0) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            });
          }
        }
      }
    });
    if (!askedMessages) {
      chat.requestMessages();
      askedMessages = true;
    }
    ontxt.listen((msg) {
      if (msg.group != group.id || lastMessage.toString() == msg.toString()) {
        return;
      }
      messages.add(msg);
      lastMessages[idToIndex[group.id]!] = msg;
      lastMessage = msg;
      if (ModalRoute.of(context) != null && ModalRoute.of(context)!.isCurrent) {
        setState(() {});
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          start += 20;
          chat.requestMessages(start);
        }
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(group.name),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (_, index) => GestureDetector(
                            onLongPress: () async {
                              // LONG PRESS COPY THE MESSAGE
                              await Clipboard.setData(
                                  ClipboardData(text: messages[index].text));
                            },
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 170),
                              child: Row(children: [
                                SizedBox(
                                  width: messages[index].user == user.id
                                      ? MediaQuery.of(context).size.width * 0.2
                                      : 0,
                                ),
                                Container(
                                    margin: const EdgeInsets.all(1),
                                    padding: const EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width *
                                        0.79,
                                    decoration: BoxDecoration(
                                        color: messages[index].user == user.id
                                            ? Colors.green
                                            : Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      // messaggio
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // name
                                              Text(messages[index].user,
                                                  style: textStyleBold),
                                              // date
                                              Text(messages[index].time,
                                                  style: textStyle)
                                            ]),
                                        // text
                                        Text(
                                          messages[index].text,
                                          style: textStyle,
                                        ),
                                      ],
                                    )),
                              ]),
                            )))),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.97,
                  child: TextFormField(
                      controller: tec,
                      maxLines: 3,
                      style: textStyle,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Message",
                          suffixIcon: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.blue),
                            child: ElevatedButton(
                              onPressed: sendMessage,
                              child: const Icon(Icons.send_rounded),
                            ),
                          )),
                      onChanged: (val) => currentText = val,
                      maxLength: 126),
                ),
              ])),
        ));
  }
}
