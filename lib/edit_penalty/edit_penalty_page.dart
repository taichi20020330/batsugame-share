import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../add_penalty/add_penalty_model.dart';
import '../domain/penalty.dart';

import 'edit_penalty_model.dart';

class EditPenaltyPage extends StatelessWidget {
  final Penalty penalty;
  EditPenaltyPage(this.penalty);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditPenaltyModel>(
      create: (_) => EditPenaltyModel (penalty),
      child: Scaffold(
        appBar: AppBar(
          title: Text( '罰ゲームの編集'),
        ),
        body: Center(
          child: Consumer<EditPenaltyModel>(builder: (context, model, child) {
            return Column(children:[
              TextField(
                controller: model.titleController,
                decoration: InputDecoration(
                  hintText: '罰ゲーム名',
                ),
                onChanged: (text) {
                  model.setTitle(text);

                },
              ),
              SizedBox(height:16,),
              ElevatedButton(
                  onPressed: model.isUpdate() ? () async{
                //追加の処理
                try{
                  await model.updatePenalty();
                  Navigator.of(context).pop(true);

                }catch(e){
                  final snackBar= SnackBar(
                    content:Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }: null, child: Text('更新する')),
            ],);
          }),
        ),
      ),
    );
  }
}