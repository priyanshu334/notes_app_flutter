import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  void opeNoteBox(String? docId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docId == null) {
                        firestoreService.addNote(textController.text);
                      } else {
                        firestoreService.updateNote(docId, textController.text);
                      }
                      textController.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Add"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.black,
        title: Center(child: Text("Notes",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => opeNoteBox(null),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List noteList = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: noteList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documnet = noteList[index];
                    String docId = documnet.id;

                    Map<String, dynamic> data =
                        documnet.data() as Map<String, dynamic>;
                    String noteText = data['note'];
                    return ListTile(
                        title: Text(noteText),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: ()=>opeNoteBox(docId), icon: Icon(Icons.edit)),
                              IconButton(onPressed: ()=>firestoreService.deleteNote(docId), icon: Icon(Icons.delete)),
                            
                          ],
                        ));
                  });
            } else {
              return Text("No Notes .....");
            }
          }),
    );
  }
}
