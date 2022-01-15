import 'package:flutter/material.dart';
import 'package:test_flutter_project/util/local_notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          NotificationApi.localNotification(
              id: 007,
              title: 'Hello',
              body: 'Hello World is old now. The World is changing');
        },
        child: const Text('Get Notification'),
      ),
    );
  }
}
