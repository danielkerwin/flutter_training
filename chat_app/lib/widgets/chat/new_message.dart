import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  final _messageFocusNode = FocusNode();

  void _sendMessage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final user =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _messageController.text,
      'createdAt': Timestamp.now(),
      'userId': uid,
      'username': user['username']
    });
    _messageController.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _messageFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Enter a message'),
              onChanged: (val) => setState(() {}),
              onSubmitted: _messageController.text.trim().isEmpty
                  ? null
                  : (val) => _sendMessage(),
            ),
          ),
          IconButton(
            onPressed:
                _messageController.text.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
            // color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
