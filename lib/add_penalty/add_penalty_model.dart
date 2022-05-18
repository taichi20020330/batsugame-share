import 'package:batsugame_share/add_penalty/add_penalty_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AddPenaltyModel extends ChangeNotifier{

  String? title;
  List<String> tags = [];
  int level = 1;
  List<String> preInstallList = [];

   addPenalty() async{
    if(title == null || title == ""){
      throw '罰ゲーム名が入力されていません';
    }

    await FirebaseFirestore.instance.collection('penalties').add({
      'title': title,
      'createdAt':Timestamp.now(),
      'tags': tags,
      'level': level,
    });
  }

  addLocalPenalty() async{
    if(title == null || title == ""){
      throw '罰ゲーム名が入力されていません';
    }
    final prefs = await SharedPreferences.getInstance();
    final List<String>? preLocalPenalties = prefs.getStringList('localPenalties');
    preInstallList = preLocalPenalties!;
    preInstallList.add(title!);
    await prefs.setStringList('localPenalties', preInstallList);
   }

}