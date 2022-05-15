import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class settingsPage extends StatelessWidget {
  final Uri _twitterurl = Uri.parse('https://twitter.com/pinoko2222');
  final Uri _instaurl = Uri.parse('https://www.instagram.com/pinoko72447/');
  final Uri _policyurl = Uri.parse('https://qiita.com/pinoko72447/items/b8c804d5065d049cff22');


  void _twitterUrl() async {
    if (!await launchUrl(_twitterurl)) throw 'Could not launch $_twitterurl';
  }

  void _instaUrl() async {
    if (!await launchUrl(_instaurl)) throw 'Could not launch $_instaurl';
  }

  void _policyUrl() async {
    if (!await launchUrl(_policyurl)) throw 'Could not launch $_policyurl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title : Text("開発者について"),
          backgroundColor: Colors.green[800],
        ),
        body : Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child:  Image.asset('nakamura.JPG',width: 300,),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                child: Text("中村太一",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),),
              ),
              Text("香川出身の大学生。照り焼きチキンを作ろうとしたら、レンジが発火したことがある。"),
              Padding(
                padding: const EdgeInsets.only(top:30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.twitter),
                      onPressed: _twitterUrl
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.instagram),
                      onPressed: _instaUrl
                    ),
                    IconButton(
                      icon:  Icon(FontAwesomeIcons.circleInfo),
                      onPressed: _policyUrl
                    ),

                    IconButton(
                      icon:  Icon(FontAwesomeIcons.paw),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title:Text('もみじ'),
                              content: Image.asset('momiji.JPG',width: 300,),
                            );
                          },
                        );
                      },
                    ),



                  ],
                ),
              )
            ],
            // child:TextButton(
            //   onPressed: _launchUrl,
            //   child: Text('Show Flutter homepage'),
            // ),

          ),
        )
    );
  }
}
