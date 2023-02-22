import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final chatDocuments = streamSnapshot.data!.docs;
          if (streamSnapshot.hasData && streamSnapshot.data != null) {
            return ListView.builder(
              reverse: true,
              itemCount: chatDocuments.length,
              itemBuilder: (ctx, index) {
                return MessageBubble(
                  chatDocuments[index].get('text'),
                  //chatDocuments[index].get('userId'),
                );
              },
            );
          }
          return Center(
            child: Text('No messages yet'),
          );
        });
  }
}
