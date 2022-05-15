import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:batsugame_share/roulette_edit.dart';


class RoulettePage extends StatefulWidget {
  RoulettePage(this.roulette_items, this.excepted_penalties_title);
  List<String> roulette_items;
  List<String> excepted_penalties_title;

  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<RoulettePage> {
  StreamController<int> selected = StreamController<int>();
  int value = 0;
  bool routating = false;
  bool isVisible = false;
  final player = AudioCache();
  int roulette_cnt = 0;

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backButtonPress(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('罰ゲームルーレット'),
          backgroundColor: Colors.green[800],
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () async {
                var changedItems = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      RouletteEditPage(widget.roulette_items, widget.excepted_penalties_title)),
                );
                setState(() {
                  isVisible = false;
                  widget.roulette_items = changedItems;
                });
              },
            )
          ],

        ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 120),
                height: 50,
                child: Visibility(
                  visible: isVisible,
                  child: Text(
                    widget.roulette_items[value],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                ),
              ),

              Container(
                height: 350,
                child: FortuneWheel(
                  animateFirst: false,
                  rotationCount: 50,
                  selected: selected.stream,
                  indicators: const <FortuneIndicator>[
                    FortuneIndicator(
                      alignment: Alignment.topCenter,
                      child: TriangleIndicator(
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                  items: [
                    for (var i = 0; i < widget.roulette_items.length; i++)
                      FortuneItem(
                        child: Transform.rotate(
                          angle: i > (widget.roulette_items.length / 2) ? math
                              .pi : 0,
                          child: Text(widget.roulette_items[i]),
                        ),

                      ),
                  ],
                  onAnimationEnd: () {
                    player.play('drumroll_end.mp3');
                    isVisible = true;
                    Future.delayed(Duration(seconds: 3), () {
                      routating = false;
                    });
                    setState(() {});
                  },
                ),
              ),
      GestureDetector(
        onTap: () {
          setState(() {
            if(routating == false){
              isVisible = false;
              routating = true;
              player.play('drumroll.mp3');
              value = Random().nextInt(widget.roulette_items.length);
              selected.add(value);
            }

          });
        },
        child:Container(
          padding: const EdgeInsets.all(30),
          height: 100,
            child: const Text(
                'スタート',
                style: TextStyle(fontSize: 16),)

            ),
        ),
            ],
          ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () async {
        //     InputDialog(context);
        //     final prefs = await SharedPreferences.getInstance();
        //     await prefs.setStringList(
        //         'my_string_list_{$roulette_cnt}', widget.roulette_items);
        //         roulette_cnt++;
        //   },
        //   icon: const Icon(Icons.download),
        //   label: const Text('保存する'),
        //
        // ),
      ),
    );
  }

  Future<bool> _backButtonPress(BuildContext context) async {
    bool? answer = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('ルーレットが破棄されますがよろしいですか？'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('キャンセル')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('戻る')),
            ],
          );
        });
    return answer ?? false;
  }
}