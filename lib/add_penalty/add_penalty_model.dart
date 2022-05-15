import 'package:batsugame_share/add_penalty/add_penalty_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';



class AddPenaltyModel extends ChangeNotifier{
  String? title;
  List<Tag> tags = [];

   addPenalty() async{
    if(title == null || title == ""){
      throw '罰ゲーム名が入力されていません';
    }

    await FirebaseFirestore.instance.collection('penalties').add({
      'title': title, // John Doe
      'createdAt':Timestamp.now(),
    });
  }
}