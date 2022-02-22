import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _chatStream,
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        final docs = chatSnapshot.data?.docs;
        final uid = FirebaseAuth.instance.currentUser?.uid;
        return ListView.builder(
          reverse: true,
          itemCount: docs?.length ?? 0,
          itemBuilder: (ctx, idx) {
            return MessageBubble(
              message: docs?[idx]['text'],
              createdAt: docs?[idx]['createdAt'],
              username: docs?[idx]['username'],
              isMe: uid == docs?[idx]['userId'],
              key: ValueKey(docs?[idx].id),
            );
          },
        );
      },
    );
  }
}
