import 'package:objectbox/objectbox.dart';

// @ではじまる記述をアノテーション
@Entity()
class LifeEvent{
  LifeEvent({
    required this.title,
    required this.count,
  });
  // idが必ず必要になる。初期値は0
  int id = 0;

  // イベント名
  String title;

  // イベント回数
  int count;
}