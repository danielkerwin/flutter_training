import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/ui.provider.dart';
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  addMessage() {
    FirebaseFirestore.instance
        .collection('chat/uudnkv5jmKJY3WlAy3P7/messages')
        .add({'text': 'hello'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: Consumer<UI>(
          builder: (_, ui, __) => IconButton(
            icon: ui.isDarkMode
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
            onPressed: () =>
                Provider.of<UI>(context, listen: false).toggleDarkMode(),
          ),
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButton(
                dropdownColor: Theme.of(context).colorScheme.tertiary,
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                items: [
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        )
                      ],
                    ),
                    value: 'logout',
                  ),
                ],
                onChanged: (item) {
                  if (item == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        child: Column(
          children: const [
            Expanded(child: Messages()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
