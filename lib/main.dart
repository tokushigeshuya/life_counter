import 'package:flutter/material.dart';
import 'package:life_counter/life_event.dart';
import 'package:life_counter/objectbox.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LifeCounterPage()
    );
  }
}

class LifeCounterPage extends StatefulWidget {
  const LifeCounterPage({super.key});

  @override
  State<LifeCounterPage> createState() => _LifeCounterPageState();
}

class _LifeCounterPageState extends State<LifeCounterPage> {
  // 型名の後に?をつけることでnullを許可する
  Store? store;
  Box<LifeEvent>? LifeEventBox;
  List<LifeEvent> LifeEvents = [];

  Future<void> initialize() async{
    store = await openStore();
    LifeEventBox = store?.box<LifeEvent>();
    // lifeEventsがnullだった場合はlifeEvents変数にからのListを代入する。nullじゃない場合はgetAllが実行されlifeEventの一覧が代入される
    LifeEvents = LifeEventBox?.getAll() ?? [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('人生カウンター'),
      ),
      body: ListView.builder(
        itemCount: LifeEvents.length,
        itemBuilder: (context, index){
          final LifeEvent = LifeEvents[index];
          return Text(LifeEvent.title);
        }
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            // 次の画面の情報を受け取る
            final newLifeEvent = await Navigator.of(context).push<LifeEvent>(
              MaterialPageRoute(
                builder: (context){
                  // 遷移先のページ
                  return const AddLifeEventPage();
                }
                ),
            );
            if (newLifeEvent != null ){
              LifeEventBox?.put(newLifeEvent);
              LifeEvents = LifeEventBox?.getAll() ?? [];
              setState(() {});
            }
          },
        ),
    );
  }
}

class AddLifeEventPage extends StatefulWidget {
  const AddLifeEventPage({super.key});

  @override
  State<AddLifeEventPage> createState() => _AddLifeEventPageState();
}

class _AddLifeEventPageState extends State<AddLifeEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ライフイベント追加'),
      ),
      body: TextFormField(
        onFieldSubmitted: (text){
          // インスタンスの作成
          final lifeEvent = LifeEvent(title: text, count: 0);
          // 前のページにインスタンスを渡す
          // pop(渡したい値があればここに書く、なければ何も書かなくていい)
          Navigator.of(context).pop(LifeEvent);
        },
      ),
    );
  }
}