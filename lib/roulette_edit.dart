import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:batsugame_share/services/admob.dart';

class RouletteEditPage extends StatefulWidget {
  List<String> selected_penalties_title = [];
  List<String> excepted_penalties_title = [];


  RouletteEditPage(this.selected_penalties_title ,this.excepted_penalties_title);
  @override
  _PenaltyListState createState() => _PenaltyListState();
}

class _PenaltyListState extends State<RouletteEditPage> {
  late TextEditingController myController;

  void _changePenaltyTitle(String penalty_title){
    setState(() {
      int index = widget.selected_penalties_title.indexOf(penalty_title);
      widget.selected_penalties_title[index] = myController.text;
      const snackBar = SnackBar(
        backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        content: Text('罰ゲーム名を編集しました'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
  void _deletePenaltyTitle(String penalty_title){
    setState(() {
      if(widget.selected_penalties_title.length > 2){
        widget.selected_penalties_title.remove(penalty_title);
        widget.excepted_penalties_title.add(penalty_title);
        final snackBar = SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Text('『$penalty_title』を削除しました'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        const snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content: Text('罰ゲームは2つ以上必要です'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
  void _addPenaltyTitle(String penalty_title){
    setState(() {
      widget.selected_penalties_title.add(penalty_title);
      widget.excepted_penalties_title.remove(penalty_title);
      final snackBar = SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text('『$penalty_title』を追加しました'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }


  @override
  void initState() {
    super.initState();
    myController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets= widget.selected_penalties_title
        .map(
          (penalty_title)=> Slidable(
        actionPane: const SlidableDrawerActionPane(),
        child: ListTile(
          trailing: const Icon(Icons.arrow_back),
          title: Text(penalty_title),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
              caption: '編集',
              color: Colors.black45,
              icon: Icons.edit,
              onTap: () async {
                InputDialog(context, penalty_title);
              }
          ),
          IconSlideAction(
              caption: '削除',
              color: Colors.red,
              icon: Icons.delete,
              onTap: ()  {
                _deletePenaltyTitle(penalty_title);
              }
          ),
        ],
      ),
    ).toList();
    List<Widget> excepted_widgets = widget.excepted_penalties_title
        .map(
            (penalty_title) => ListTile(
          trailing: const Icon(Icons.add),
          title: Text(penalty_title),
          onTap: () {
            _addPenaltyTitle(penalty_title);
            Navigator.pop(context, true);
          },
        )
    ).toList();
      return WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop(widget.selected_penalties_title);
            return Future.value(false);
          },
        child: Scaffold(
          appBar: AppBar(
            title: const Text( '罰ゲームの編集'),
            backgroundColor: Colors.green[800],
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (childContext) {
                      return StatefulBuilder(
                        builder: (context, setState)
                      {
                        setState(() {
                          excepted_widgets = widget.excepted_penalties_title
                              .map(
                                  (penalty_title) => ListTile(
                                trailing: const Icon(Icons.add),
                                title: Text(penalty_title),
                                onTap: () {
                                  _addPenaltyTitle(penalty_title);
                                  Navigator.pop(context, true);
                                },
                              )
                          ).toList();
                        });
                        return SimpleDialog(
                            title: const Text("罰ゲームの追加"),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    5))),
                            children: excepted_widgets
                        );
                      }
                      );
                    },
                  );
                }
              )
            ],
          ),
            body: ListView(
            children: widgets,
        ),
          bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AdmobBanner(
              adUnitId: AdMobService().getBannerAdUnitId()!,
              adSize: AdmobBannerSize(
                width: MediaQuery.of(context).size.width.toInt(),
                height: AdMobService().getHeight(context).toInt(),
                name: 'SMART_BANNER',
              ),
            ),
          ],
        ),

        ),

      );

 // This trailing comma makes auto-formatting nicer for build methods.
  }

  Future<void> InputDialog(BuildContext context, String penalty_title) async {
    myController = TextEditingController(text: penalty_title);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('罰ゲーム名の修正'),
            content: TextField(
              controller: myController,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('キャンセル'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  //OKを押したあとの処理
                  _changePenaltyTitle(penalty_title);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}


