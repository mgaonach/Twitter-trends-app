import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:twitter_trends/apiAccess.dart';
import 'package:twitter_trends/trendView/global.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter trends',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Trend> trends = [];
  DateTime lastRefresh;

  @override
  void initState() {
    super.initState();
    _loadTrends();
  }

  Future<void> _loadTrends() async {
    List<Trend> values = await getTrendsTop10();
    setState(
      () {
        this.trends = values;
      },
    );
  }

  final TextEditingController _search = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: TextField(
            controller: _search,
            showCursor: false,
            cursorColor: Colors.black12,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 17),
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Search...',
              contentPadding: EdgeInsets.all(6),
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            child: FlatButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => {},
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            width: 60,
          ),
        ],
      ),
      body: buildTrendsView(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                  child: Text(
                "Favorites",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              )),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            ListTile(
              title: Text("#IoT"),
            ),
            Divider(),
            ListTile(
              title: Text("Machine learning"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTrendsView() {
    if (trends.isEmpty) {
      return Center(
        child: SpinKitCircle(
          color: Colors.blue,
          size: 50.0,
        ),
      );
    }
    return Container(
      child: Center(
        child: RefreshIndicator(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              child: Global(
                trends: trends,
              ),
              height: MediaQuery.of(context).size.height - 100,
            ),
          ),
          onRefresh: _loadTrends,
        ),
      ),
    );
  }
}
