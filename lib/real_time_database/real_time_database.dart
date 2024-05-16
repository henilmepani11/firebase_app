import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RealTimeDatabaseDemo extends StatefulWidget {
  const RealTimeDatabaseDemo({super.key});

  @override
  State<RealTimeDatabaseDemo> createState() => _RealTimeDatabaseDemoState();
}

class _RealTimeDatabaseDemoState extends State<RealTimeDatabaseDemo> {
  TextEditingController textEditingController = TextEditingController();

  addNote() {
    FirebaseDatabase.instance
        .ref("Post")
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      "id": DateTime.now().millisecondsSinceEpoch,
      "text": textEditingController.text,
    });

    setState(() {});
    Navigator.pop(context);
  }

  updateData({id}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Post");

    await ref.update({
      "$id/text": "update text here",
    });
    setState(() {});
  }

  deleteData({id}) async {
    FirebaseDatabase.instance.ref("Post").child(id.toString()).remove();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real time database"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                myDialog(context, controller: textEditingController, onTap: () {
                  addNote();
                });
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
          future: FirebaseDatabase.instance.ref().child("Post").once(),
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData) {
              final userPost = snapshot.data!.snapshot.children.toList();
              return ListView.builder(
                itemCount: userPost.length,
                itemBuilder: (context, index) {
                  final data = userPost[index].value as Map?;

                  return ListTile(
                    title: Text(data?["userEmail"] ?? ""),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            onPressed: () {
                              updateData(id: data?["id"]);
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              deleteData(id: data?["id"]);
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                    subtitle: Text(data?["text"]),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

myDialog(context, {onTap, TextEditingController? controller}) {
  return showDialog(
    context: context,
    builder: (context) {
      controller?.clear();
      return AlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter text"),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                onTap();
              },
              child: const Text("Add Note"))
        ],
      );
    },
  );
}
