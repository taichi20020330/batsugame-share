import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'add_penalty_model.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddPenaltyPage extends StatefulWidget {
  static final List<String> _tags= [
    "家でやる",
    "外でやる",
    "男性向け",
    "女性向け",
    "体を動かす",
    "SNSを使う",
    "コンビニを使う",
    "お金を使う",
    "特定の人",
    "自分と向き合う",
    "笑いを取れる",
    "痛い",
    "めんどくさい",
    "恥ずかしい",
    "恋愛",
  ];

  @override
  State<AddPenaltyPage> createState() => _AddPenaltyPageState();
}

class _AddPenaltyPageState extends State<AddPenaltyPage> {
  final _items = AddPenaltyPage._tags
      .map((tag) => MultiSelectItem<String>(tag, tag.toString()))
      .toList();

  List<String> _selectedTags = [];
  Color iconColor0 = Colors.black;
  Color iconColor1 = Colors.grey;
  Color iconColor2 = Colors.grey;
  int level = 1;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddPenaltyModel>(
      create: (_) => AddPenaltyModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text( 'みんなの罰ゲーム追加'),
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
                        final resultTags = results.cast<String>();
                        _selectedTags = resultTags;
                        model.tags = _selectedTags;
                      },
                      chipDisplay: MultiSelectChipDisplay(
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                      child: Row(
                        children: [
                          const Text(
                            "キツさ",
                            style: TextStyle(
                                fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          skullIcon(0, iconColor0),
                          skullIcon(1, iconColor1),
                          skullIcon(2, iconColor2),
                        ],
                      ),
                    ),
                    const SizedBox(height:8,),
                    ElevatedButton(onPressed: () async{
                      try{
                        model.level = level;
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

  Widget skullIcon(int i, Color funcIconColor){
    return IconButton(
      icon:   Icon(
        FontAwesomeIcons.skull,
        size:30,
        color: funcIconColor,
      ),
      onPressed: () {
        setState(() {
          switch(i){
            case 0:
              iconColor0 = Colors.black87;
              iconColor1 = Colors.grey;
              iconColor2 = Colors.grey;
              level = 1;
              break;
            case 1:
              iconColor0 = Colors.black87;
              iconColor1 = Colors.black87;
              iconColor2 = Colors.grey;
              level = 2;
              break;
            case 2:
              iconColor0 = Colors.black87;
              iconColor1 = Colors.black87;
              iconColor2 = Colors.black87;
              level = 3;
              break;
          }
        });
      },
    );
  }
}

