import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../add_penalty/add_penalty_page.dart';
import '../domain/penalty.dart';



class PenaltyListModel extends ChangeNotifier{
  List<Penalty> penalties = [];
  List<String> penaltyNames = [];

  void fetchPenaltyList() async{
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('penalties').orderBy('createdAt', descending: true).get();
    final List<Penalty> penalties = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final Timestamp createdAt = data['createdAt'];
      return Penalty(id, title, false, [], createdAt);
    }).toList();
      this.penalties = penalties;
      notifyListeners();
  }

  void fetchTitleList() async{
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('penalties').orderBy('createdAt', descending: false).get();
    for (var doc in snapshot.docs) {
        penaltyNames.add('${doc["title"]}');
      }
    notifyListeners();
    }


  Future deletePenalty(Penalty penalty) {
    return FirebaseFirestore.instance.collection('penalties').doc(penalty.id).delete();
  }
}
