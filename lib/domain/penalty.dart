import 'package:cloud_firestore/cloud_firestore.dart';

import '../add_penalty/add_penalty_page.dart';

class Penalty{
  Penalty(this.id, this.title, this.value, this.tags, this.createdAt, this.level);
  String title;
  String id;
  bool value = false;
  List<String> tags = [];
  int level = 1;
  Timestamp createdAt;
}

