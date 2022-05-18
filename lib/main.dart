import 'package:admob_flutter/admob_flutter.dart';
import 'package:batsugame_share/penalty_list/penalty_list_model.dart';
import 'package:batsugame_share/roulette_play.dart';
import 'package:batsugame_share/services/admob.dart';
import 'package:batsugame_share/settings/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../add_penalty/add_penalty_page.dart';
import '../domain/penalty.dart';
import '../firebase_options.dart';
import 'add_penalty/add_penalty_local_page.dart';
import 'domain/localPenalty.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const DefaultTabController(
          length: 2,
          child: MyHomePage(
            title: "罰ゲーム一覧",
          )),
      //home:  PenaltyListPage(),
    );
  }


  static const MaterialColor customGreen = MaterialColor(
    _greenPrimaryValue,
    <int, Color>{
      50: Color(0xFF326E1A),
      100: Color(0xFF326E1A),
      200: Color(0xFF326E1A),
      300: Color(0xFF326E1A),
      400: Color(0xFF326E1A),
      500: Color(0xFF38761D),
      600: Color(_greenPrimaryValue),
      700: Color(0xFF2B6315),
      800: Color(0xFF245911),
      900: Color(0xFF17460A),
    },
  );
  static const int _greenPrimaryValue = 0xFF326E1A;
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key? key,
    required this.title,
    required this.padding,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(title)),
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Penalty> selected_penalties = [];
  final List<String> selected_penalties_title = [];
  List<Penalty> penalties = [];
  List<localPenalty> localPenalties = [];

  final List<String> penalties_title = [];
  final List<String> excepted_penalties_title = [];
  bool isSelected = false;
  bool isPrivate = false;

  void _resetArray() {
    setState(() {
      selected_penalties_title.clear();
      excepted_penalties_title.clear();
      for (var penalty in penalties) {
        penalty.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PenaltyListModel>( create: (_) => PenaltyListModel()..fetchLocalPenaltyList()),
        ChangeNotifierProvider<PenaltyListModel>( create: (_) => PenaltyListModel()..fetchPenaltyList()),
      ],
        child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'みんなのやつ'),
                  Tab(text: '自分のやつ'),
                ],
              ),
              title: Text(widget.title),
              backgroundColor: Colors.green[800],
              leading: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => settingsPage()));
                },
              ),
              actions: <Widget>[
                Consumer<PenaltyListModel>(builder: (context, model, child) {
                  return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      if (isPrivate == false) {
                        final bool? added = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPenaltyPage(),
                            fullscreenDialog: true,
                          ),
                        );
                        if (added != null && added) {
                          const snackBar = SnackBar(
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                            content: Text('罰ゲームを公開しました'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          model.fetchPenaltyList();
                        }
                      } else {
                        final bool? added = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPenaltyLocalPage(),
                            fullscreenDialog: true,
                          ),
                        );
                        if (added != null && added) {
                          const snackBar = SnackBar(
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                            content: Text('罰ゲームを追加しました'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          model.fetchLocalPenaltyList();
                        }
                      }
                    },
                  );
                })
              ],
            ),
            body: TabBarView(
              children: [
                //　みんなのやつ
                Consumer<PenaltyListModel>(builder: (context, model, child) {

                  isPrivate = false;
                  penalties = model.penalties;
                  isSelected = false;
                  for (var penalty in penalties) {
                    if (penalty.value) {
                      isSelected = true;
                    }
                  }
                  final List<Widget> penaltyWidgets = penalties
                      .map(
                        (penalty) => Column(
                      children: [
                        CheckboxListTile(
                          title: Text(
                            penalty.title,
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          value: penalty.value,
                          onChanged: (bool? newValue) {
                            setState(() {
                              penalty.value = newValue!;
                            });
                          },
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              for (var i = 0; i < penalty.level; i++)
                                skullIcon(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ).toList();
                  return RefreshIndicator(
                    onRefresh: () async {
                      model.fetchPenaltyList();
                    },
                    child: ListView(children: penaltyWidgets),
                  );
                }),

                //　自分のやつ
                Consumer<PenaltyListModel>(builder: (context, model, child) {
                  isPrivate = true;
                  localPenalties = model.localPenalties;
                  isSelected = false;
                  for (var penalty in localPenalties) {
                    if (penalty.value) {
                      isSelected = true;
                    }
                  }
                  final List<Widget> localPenaltyWidgets = localPenalties
                      .map(
                        (penalty) => Column(
                      children: [
                        CheckboxListTile(
                          title: Text(
                            penalty.title,
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          value: penalty.value,
                          onChanged: (bool? newValue) {
                            setState(() {
                              penalty.value = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ).toList();
                  return RefreshIndicator(
                    onRefresh: () async {
                      model.fetchLocalPenaltyList();
                    },
                    child: ListView(children: localPenaltyWidgets),
                  );
                })
              ],
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
            floatingActionButton:
            Consumer<PenaltyListModel>(builder: (context, model, child) {
              if (isSelected) {
                return FloatingActionButton.extended(
                  backgroundColor: Colors.green[800],
                  onPressed: () async {
                    for (var penalty in penalties) {
                      if (penalty.value) {
                        selected_penalties_title.add(penalty.title);
                      } else {
                        excepted_penalties_title.add(penalty.title);
                      }
                    }

                    for (var penalty in localPenalties) {
                      if (penalty.value) {
                        selected_penalties_title.add(penalty.title);
                      } else {
                        excepted_penalties_title.add(penalty.title);
                      }
                    }

                    if (selected_penalties_title.length > 1) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoulettePage(
                                selected_penalties_title,
                                excepted_penalties_title)),
                      );
                      _resetArray();
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: const Text("2つ以上選択してください！"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  label: const Text("ルーレット作成"),
                  icon: const Icon(Icons.arrow_forward),
                );
              } else {
                return FloatingActionButton.extended(
                  backgroundColor: Colors.green[800],
                  onPressed: () {
                    InputDialog(context);
                  },
                  label: const Text("ランダム作成"),
                  icon: const Icon(Icons.arrow_forward),
                );
              }
            })),

    );
  }

  Widget skullIcon() {
    return const Padding(
      padding: EdgeInsets.only(right: 2.0),
      child: Icon(
        FontAwesomeIcons.skull,
        size: 14,
        color: Colors.grey,
      ),
    );
  }

  Future<void> InputDialog(BuildContext context) async {
    double _value = 5;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('ランダム作成'),
              content: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Slider(
                      min: 2,
                      max: penalties.length.toDouble(),
                      divisions: penalties.length - 2,
                      label: '${_value.toInt()}',
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                    Text('${_value.toInt()}個の罰ゲームを新しく追加する')
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('キャンセル'),
                  onPressed: () {
                    Navigator.pop(context);
                    _resetArray();
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    setState(() {
                      List<int> randomNumList = [];
                      for (var i = 0; i < penalties.length; i++) {
                        randomNumList.add(i);
                      }
                      randomNumList.shuffle();
                      for (var i = 0; i < penalties.length; i++) {
                        int randomIndex = randomNumList[i];
                        if (i < _value) {
                          selected_penalties_title
                              .add(penalties[randomIndex].title);
                        } else {
                          excepted_penalties_title
                              .add(penalties[randomIndex].title);
                        }
                      }
                    });
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoulettePage(
                              selected_penalties_title,
                              excepted_penalties_title)),
                    );
                    _resetArray();
                  },
                ),
              ],
            );
          });
        });
  }
}
