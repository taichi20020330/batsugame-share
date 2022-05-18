import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/localPenalty.dart';
import '../domain/penalty.dart';

class PenaltyListModel extends ChangeNotifier{

  //みんなのやつ
  List<Penalty> penalties = [];
  List<String> penaltyNames = [];
  List<localPenalty> localPenalties = [];

  void fetchPenaltyList() async{
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('penalties').orderBy('createdAt', descending: true).get();
    final List<Penalty> penalties = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final Timestamp createdAt = data['createdAt'];
      final List<String> tags = data['tags'].cast<String>();
      final level = data['level'];
      return Penalty(id, title, false, tags, createdAt, level);
    }).toList();
      this.penalties = penalties;
    notifyListeners();
  }

  //自分のやつ
  void fetchLocalPenaltyList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? preLocalPenalties = prefs.getStringList('localPenalties');
    final result = preLocalPenalties?.map((local) {
      final String localTitle = local;
      return localPenalty(localTitle, false);
    }).toList();
    localPenalties = result!;
    notifyListeners();
  }

  Future deletePenalty(Penalty penalty) {
    return FirebaseFirestore.instance.collection('penalties').doc(penalty.id).delete();
  }
}
