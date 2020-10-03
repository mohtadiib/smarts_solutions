import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Table Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Premier League'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _clubNames = [
    'Man City',
    'Liverpool',
    'Chelsea',
    'Spurs',
    'Arsenal',
    'Man United',
    'Wolves',
    'Everton',
    'Leicester',
    'Watford',
    'West Ham',
    'Crystal Palace',
    'Man City 1',
    'Liverpool 1',
    'Chelsea 1',
    'Spurs 1',
    'Arsenal 1',
    'Man United 1',
    'Wolves 1',
    'Everton 1',
    'Leicester 1',
    'Watford 1',
    'West Ham 1',
    'Man City 2',
    'Liverpool 2',
    'Chelsea 2',
    'Spurs 2',
    'Arsenal 2',
    'Man United 2',
    'Wolves 2',
    'Everton 2',
    'Leicester 2',
    'Watford 2',
    'West Ham 2',
  ];
  List<ClubData> _clubData;
  bool _useListStyle = true;

  @override void initState() {
    _clubData = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
            children: <Widget> [
              Container(
                color: Colors.grey[300],
                height: 8.0,
              ),
              Container(
                color: Colors.grey[300],
                child: (_useListStyle) ? getListStyleHeader() : getTileStyleHeader(),
              ),
              Container(
                color: Colors.grey[300],
                height: 8.0,
              ),
              Expanded(
                child: Scrollbar(
                  child: NotificationListener<ScrollNotification>(
                    child: ListView.builder(
                      shrinkWrap: true,
                      key: const ValueKey<String>('clubs-list'),
                      padding:  EdgeInsets.only(top: 2.0, bottom: 2.0),
                      itemCount: (_clubData == null) ? 0 : _clubData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return (_useListStyle) ? _buildListStyleRow(index) : _buildTileStyleRow(index);
                      },
                    ),
                  ),
                ),
              ),
            ]
        ),
      ),
      floatingActionButton: Opacity(
        opacity: 0.45,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _useListStyle = !_useListStyle;
            });
          },
          tooltip: 'Increment',
          child: Icon(Icons.swap_calls),
        ),
      ),
    );
  }

  Widget getListStyleHeader() {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: 28.0,
        ),
        Expanded(
          flex: 8,
          child: Text('Club name', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
        ),
        Expanded(
          child: Text('M', textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0)),
        ),
        SizedBox(
          width: 4.0,
        ),
        Expanded(
          child: Text('W', textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0)),
        ),
        SizedBox(
          width: 4.0,
        ),
        Expanded(
          child: Text('D', textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0)),
        ),
        SizedBox(
          width: 4.0,
        ),
        Expanded(
          child: Text('L', textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0)),
        ),
        SizedBox(
          width: 4.0,
        ),
        Expanded(
          child: Text('GD', textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0,)),
        ),
        SizedBox(
          width: 4.0,
        ),
        Expanded(
          flex: 2,
          child: Text('P', textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w800)),
        ),
        SizedBox(
          width: 8.0,
        ),
      ],
    )
    );
  }

  Widget _buildListStyleRow(int index) {
    ClubData club = _clubData[index];
    return Container(
      height: 36.0,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[100])
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 2.0, right: 2.0),
        child: Container(
          color: (index % 2 == 0) ? Colors.white : Colors.grey[50],
          child: Row(
              children: <Widget>[
                SizedBox(
                  width: 8.0,
                ),
                SizedBox(
                  width: 20.0,
                  child: Text((index + 1).toString() + '.', style: const TextStyle(fontSize: 10.0)),
                ),
                Expanded(
                  flex: 8,
                  child: Text(club.name, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                ),
                Expanded(
                  child: Text(club.matches.toString(), textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0)),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: Text(club.win.toString(), textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0)),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: Text(club.drawn.toString(), textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0)),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: Text(club.lose.toString(), textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0)),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: Text(club.goalDifference.toString(), textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0,)),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  flex: 2,
                  child: Text(club.points.toString(), textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w800)),
                ),
                SizedBox(
                  width: 8.0,
                ),
              ]
          ),
        ),
      ),
    );
  }

  Widget getTileStyleHeader() {
    return (Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Text('Club name', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Text('Points', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        ]
    )
    );
  }

  Widget _buildTileStyleRow(int index) {
    ClubData club = _clubData[index];
    return Theme(
        data: ThemeData(
            brightness: Brightness.light
        ),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200])
            ),
            child: ExpansionTile(
              key: PageStorageKey<String>(index.toString()),
              title: Container(
                  child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                          child: Text((index + 1).toString() + '.', style: const TextStyle(fontSize: 12.0)),
                        ),
                        Expanded(
                          child: Text(club.name, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(club.points.toString(),
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ]
                  )
              ),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
              children: buildTile(club),
            )
        )
    );
  }

  List<Widget> buildTile(ClubData club) {
    List<Widget> ret = <Widget>[];
    var container =  Container(
        margin: const EdgeInsets.only(left: 100.0, right: 100.0),
        child: Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Wins', style: const TextStyle(fontSize: 14.0,),),
                  ),
                  Text(club.win.toString(), style: const TextStyle(fontSize: 13.0),),
                ]
            ),
            Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Losses', style: const TextStyle(fontSize: 14.0,),),
                  ),
                  Text(club.lose.toString(), style: const TextStyle(fontSize: 13.0),),
                ]
            ),
            Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Drawn', style: const TextStyle(fontSize: 14.0,),),
                  ),
                  Text(club.drawn.toString(), style: const TextStyle(fontSize: 13.0),),
                ]
            ),
            Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Goal Difference', style: const TextStyle(fontSize: 14.0,),),
                  ),
                  Text(club.goalDifference.toString(), style: const TextStyle(fontSize: 13.0),),
                ]
            ),
            SizedBox(height: 14.0),
          ],
        )
    );
    ret.add(container);

    return ret;
  }

  List<ClubData> getData() {
    var rng = Random();
    List<ClubData> data = <ClubData>[];
    int i = 0;
    for (var clubName in _clubNames) {
      ClubData club = ClubData(clubName, rng.nextInt(30), rng.nextInt(100), rng.nextInt(50), rng.nextInt(50), rng.nextInt(25), 200 - i * 3);
      data.add(club);
      i++;
    }

    return data;
  }
}

class ClubData {
  String name;
  int matches;
  int win;
  int drawn;
  int lose;
  int goalDifference;
  int points;

  ClubData(this.name, this.matches, this.win, this.drawn, this.lose, this.goalDifference, this.points);
}