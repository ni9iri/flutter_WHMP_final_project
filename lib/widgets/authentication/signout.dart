import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app/widgets/chat/messages.dart';
import 'package:firebase_app/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';

class Signout extends StatefulWidget {
  const Signout({super.key});

  @override
  State<Signout> createState() => _SignoutState();
}

class _SignoutState extends State<Signout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
    );
  }
}
