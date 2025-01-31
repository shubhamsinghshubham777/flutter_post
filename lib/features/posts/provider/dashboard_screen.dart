import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Dashboard Screen'),
            FilledButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
