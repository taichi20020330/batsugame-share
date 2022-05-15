import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../domain/penalty.dart';



class EditPenaltyModel extends ChangeNotifier{

  final Penalty penalty;
  EditPenaltyModel(this.penalty) {
    titleController.text = penalty.title;
  }
  final titleController = TextEditingController();

  String? title;

  void setTitle (String title){
    this.title = title;
    notifyListeners();
  }

  bool isUpdate(){
    return title != null;
  }

  Future updatePenalty() async{
    this.title = titleController.text;
   await FirebaseFirestore.instance.collection('penalties').doc(penalty.id).update({
      'title': title, // John Doe
    });
  }
}