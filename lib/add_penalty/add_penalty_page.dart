import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_penalty_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Tag {
  final int id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });
}

class AddPenaltyPage extends StatelessWidget {
  static final List<Tag> _tag = [
    Tag(id: 1, name: "外でやる"),
    Tag(id: 2, name: "家でやる"),
    Tag(id: 3, name: "男性向け"),
    Tag(id: 4, name: "女性向け"),
    Tag(id: 5, name: "痛い"),
    Tag(id: 6, name: "体を動かす"),
    Tag(id: 7, name: "自分と向き合う"),
    Tag(id: 8, name: "特定の人"),
    Tag(id: 9, name: "笑いをとれる"),
    Tag(id: 10, name: "恥ずかしい"),
    Tag(id: 11, name: "めんどくさい"),
    Tag(id: 12, name: "お金を使う"),
    Tag(id: 13, name: "SNSを使う"),
    Tag(id: 14, name: "コンビニを使う"),
    Tag(id: 15, name: "ずっと続く"),
    Tag(id: 16, name: "恋愛"),

  ];

  final _items = _tag
      .map((tag) => MultiSelectItem<Tag>(tag, tag.name))
      .toList();
  List<Tag> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddPenaltyModel>(
      create: (_) => AddPenaltyModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text( '罰ゲームの追加'),
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
                    const SizedBox(height: 40),
                    MultiSelectDialogField(
                      items: _items,
                      title: const Text("罰ゲームの種類"),
                      selectedColor: Colors.green.withOpacity(0.1),
                      listType: MultiSelectListType.CHIP,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                      buttonIcon: const Icon(
                        Icons.local_offer,
                        color: Colors.green,
                      ),
                      buttonText: Text(
                        "どんな罰ゲーム？",
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 16,
                        ),
                      ),
                      onConfirm: (results) {
                        final resultTags = results.cast<Tag>();
                        _selectedTags = resultTags;
                        model.tags = _selectedTags;
                      },
                      chipDisplay: MultiSelectChipDisplay(
                      ),
                    ),
                    const SizedBox(height:8,),
                    ElevatedButton(onPressed: () async{
                      //追加の処理
                      try{
                        await model.addPenalty();
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
