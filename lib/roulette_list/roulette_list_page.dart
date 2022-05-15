import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../add_penalty/add_penalty_page.dart';
import '../domain/penalty.dart';
import '../edit_penalty/edit_penalty_page.dart';
import '../penalty_list/penalty_list_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PenaltyListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PenaltyListModel>(
      create: (_) => PenaltyListModel()..fetchPenaltyList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text( 'みんなの考えた罰ゲーム'),
        ),

        body: Consumer<PenaltyListModel>(builder: (context, model, child) {
          final List<Penalty>? penalties = model.penalties;
          if(penalties == null){
            return CircularProgressIndicator();
          }
          final List<Widget> widgets= penalties
              .map(
                (penalty)=> Slidable(
              actionPane: SlidableDrawerActionPane(),
              child: ListTile(
                title: Text(penalty.title),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                    caption: '編集',
                    color: Colors.black45,
                    icon: Icons.edit,
                    onTap: () async {
                      final bool? added = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  EditPenaltyPage(penalty),
                        ),
                      );
                      if(added != null && added){
                        final snackBar= SnackBar(
                          backgroundColor:Colors.green,
                          content:Text('罰ゲームを編集しました'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      model.fetchPenaltyList();

                    }
                ),
                IconSlideAction(
                    caption: '削除',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () async {
                      await showConfirmDialog(context, penalty, model);
                    }
                ),
              ],
            ),
          ).toList();
          return ListView(
              children: widgets
          );

        }),
        floatingActionButton: Consumer<PenaltyListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {

              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPenaltyPage(),
                  fullscreenDialog: true,
                ),
              );

              if(added != null && added){
                final snackBar= SnackBar(
                  backgroundColor:Colors.green,
                  content:Text('罰ゲームを追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              model.fetchPenaltyList();

            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        }
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

Future showConfirmDialog(
    BuildContext context,
    Penalty penalty,
    PenaltyListModel model,
    ) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        title: Text("削除の確認"),
        content: Text("『${penalty.title}』を削除しますか？"),
        actions: [
          TextButton(
            child: Text("いいえ"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("はい"),
            onPressed: () async {
              // modelで削除
              await model.deletePenalty(penalty);

              Navigator.pop(context);
              final snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text('『${penalty.title}』を削除しました'),
              );
              model.fetchPenaltyList();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      );
    },
  );
}

