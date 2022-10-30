import 'package:flutter/material.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/features/notification/controllers/notify_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  bool _visible = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(hours: 50), () {
      if (mounted) {
        setState(() {
          _visible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Notifications'),
      ),
      body: ref.watch(notifyControllerProvider).when(
        data: (notifies) {
          return ListView.builder(
            itemCount: notifies.length,
            itemBuilder: (context, index) {
              final notify = notifies[index];
              return Column(
                children: [
                  const Padding(padding: EdgeInsets.all(8.0)),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _visible,
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(notify.profileImg)),
                        title: Text(
                          notify.message,
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(notify.datePublished),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                  const Divider()
                ],
              );
            },
          );
        },
        error: (error, stackTrace) {
          return ErrorScreen(error: error.toString());
        },
        loading: () {
          return const Center(
            child: Loader(),
          );
        },
      ),
    );
  }
}
