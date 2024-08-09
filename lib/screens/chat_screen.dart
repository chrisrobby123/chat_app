import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arrow'),
        actions: [
          DropdownButton(
              icon: const Icon(Icons.more_vert),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        Text('Log out'),
                      ],
                    ),
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: ((value) {
                if (value == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('chats/BO6frYRAMFWpFOGF3obP/messages')
                .add({'text': 'This works as expected!!.'});
          },
          child: const Icon(Icons.add)),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats/BO6frYRAMFWpFOGF3obP/messages')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            var documents = snapshot.data!.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: ((context, index) => Container(
                      child: Text(documents[index]['text']),
                    )));
          }),
    );
  }
}
