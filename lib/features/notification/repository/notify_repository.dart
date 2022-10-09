// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_angola/models/notify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notifyRepositoryProvider = Provider<NotifyRepository>((ref) {
  return NotifyRepository(firestore: FirebaseFirestore.instance);
});

class NotifyRepository {
  final FirebaseFirestore firestore;
  NotifyRepository({
    required this.firestore,
  });

  Stream<List<Notify>> getNotificationStream() {
    return firestore
        .collection('notification')
        .orderBy('datePublished')
        .snapshots()
        .map((event) {
      List<Notify> notifies = [];
      for (var document in event.docs) {
        notifies.add(Notify.fromMap(document.data()));
      }
      return notifies;
    });
  }
}
