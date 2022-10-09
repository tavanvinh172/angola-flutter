import 'package:flutter_angola/features/notification/repository/notify_repository.dart';
import 'package:flutter_angola/models/notify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notifyControllerProvider = StreamProvider<List<Notify>>((ref) {
  final repository = ref.watch(notifyRepositoryProvider);
  return repository.getNotificationStream();
});
