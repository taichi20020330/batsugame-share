import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_penalty_model.dart';

class AddPenaltyLocalPage extends StatefulWidget {

  @override
  State<AddPenaltyLocalPage> createState() => _AddPenaltyLocalPageState();
}

class _AddPenaltyLocalPageState extends State<AddPenaltyLocalPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddPenaltyModel>(
      create: (_) => AddPenaltyModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text( '自分の罰ゲーム追加'),
          backgroundColor: Colors.green[800],
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Consumer<AddPenaltyModel>(builder: (context, model, child) {
            return Column(children:[
              TextField(
                decoration: const InputDecoration(
                  hintText: '罰ゲーム名',
                ),
                onChanged: (text) {
                  model.title = text;
                },
              ),
              const SizedBox(height:8,),
              ElevatedButton(onPressed: () async{
                try{
                  await model.addLocalPenalty();
                  Navigator.of(context).pop(true);
                }catch(e){
                  final snackBar= SnackBar(
                    content:Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }, child: const Text('追加する')),
            ],
            );

          }),
        ),
      ),
    );
  }
}

