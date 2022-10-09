import 'package:flutter/material.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/features/notification/controllers/notify_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Notification'),
        ),
        body: ref.watch(notifyControllerProvider).when(data: (notifies) {
          return ListView.builder(
            itemCount: notifies.length,
            itemBuilder: (context, index) {
              final notify = notifies[index];
              return Column(
                children: [
                  const Padding(padding: EdgeInsets.all(8.0)),
                  ListTile(
                    leading: const CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1665240571093-eb9be84fb182?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=600&q=60')),
                    title: Text(
                      notify.message,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      DateFormat.Hm().format(notify.datePublished),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              );
            },
          );
        }, error: (error, stackTrace) {
          return ErrorScreen(error: error.toString());
        }, loading: () {
          return const Center(
            child: Loader(),
          );
        }));
  }
}
