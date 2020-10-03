import 'package:best_flutter_ui_templates/providor.dart';
import 'package:best_flutter_ui_templates/screens/user/login/authservice.dart';
import 'package:best_flutter_ui_templates/utilities/routing.dart';
import 'package:best_flutter_ui_templates/widgests/app_bar_custom.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../translation_strings.dart';
import 'map_view.dart';

class VisiteTime extends StatefulWidget {
  @override
  _VisiteTimeState createState() => _VisiteTimeState();
}

class _VisiteTimeState extends State<VisiteTime> {

  String _date_en =  "not Selected";
  String _time_en = "not Selected";

  String _date_ar =  "لم يُحدد";
  String _time_ar = "لم يُحدد";

  bool checkField = false;

  String _monthSelected , _daySelected, _timeMinuteSelected ,_timehourSelected;

  date()async{
    DateTime newDateTime = await showRoundedDatePicker(
      firstDate: DateTime.now(),
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
    _monthSelected = newDateTime.month.toString();
    _daySelected = newDateTime.day.toString();
    print('date time here :'+_monthSelected);
    setState(() {
      _date_ar = '2020'+'/'+_monthSelected+'/'+_daySelected+'م';
      _date_en = '2020'+'/'+_monthSelected+'/'+_daySelected;

      if(_time_ar != 'لم يُحدد' && _date_ar != 'لم يُحدد' ||
          _time_en != 'not Selected' && _date_en != 'not Selected'){
        checkField = true;
      }
    }
    );
  }

  time() async{
    final timePicked = await showRoundedTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    _timehourSelected = timePicked.hour.toString();
    _timeMinuteSelected = timePicked.minute.toString();

    setState(() {
      _time_ar = 'H:'+_timehourSelected+' - M:'+_timeMinuteSelected;
      _time_en = 'H:'+_timehourSelected+' - M:'+_timeMinuteSelected;

      if(_time_ar != 'لم يُحدد' && _date_ar != 'لم يُحدد' ||
          _time_en != 'not Selected' && _date_en != 'not Selected'){
        checkField = true;
      }
     }
    );

    print('_time_ar here :'+_time_ar);
    print('_time_en here :'+_time_en);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthService().setTestPage(3);
    _showButton();
  }

  bool _notific;

  _showButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _notifi = prefs.getBool('notifi');

    setState(() {
      _notific = _notifi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppModel.lamgug?TextDirection.rtl:TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              customAppBar(AppModel.lamgug?'طلب زيارة للموقع':'Visit Order' ,context),
              Align(
                alignment: FractionalOffset.center,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    child:  Image(
                      image: AssetImage(
                        'assets/images/feedbackImage.png',
                      ),
                      height: MediaQuery.of(context).size.height*0.3,
                      width: MediaQuery.of(context).size.width*0.7,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: FractionalOffset.center,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50 ,left: 50),
                      child: Text(Translations.of(context).visite_sub_title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                            fontSize: 14,color: Colors.grey[600]
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              lineDraw(),
              Directionality(
                textDirection: _textLang() == 'Next'? TextDirection.ltr : TextDirection.rtl,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 50,left: 50),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          date();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: Theme.of(context).primaryColor,
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Text(
                                _textLang() == 'Next'? 'Date': "التاريخ",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Spacer(
                                flex: 4,
                              ),
                              Text(
                                _textLang() == 'Next'?_date_en:_date_ar,
                                style: TextStyle(
                                    color: _date_ar == "لم يُحدد" ? Colors.grey : Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Spacer(
                                flex: 7,
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 50,left: 50),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          time();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                size: 18.0,
                                color: Theme.of(context).primaryColor,
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Text(
                                _textLang() == 'Next'? 'Time':"الوقت",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Spacer(
                                flex: 4,
                              ),
                              Text(
                                _textLang() == 'Next'?_time_en:_time_ar,
                                style: TextStyle(
                                    color: _time_ar == "لم يُحدد"? Colors.grey : Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Spacer(
                                flex: 7,
                              ),

                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              lineDraw(),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5,right: 50,left: 50),
                    child: Container(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          onPressed: () {
                            if(_time_ar != 'لم يُحدد' && _date_ar != 'لم يُحدد' ||
                                _time_en != 'not Selected' && _date_en != 'not Selected'){
                              Navigator.of(context);
                              Navigator.of(context).push(PageRouteTransition(
                                  animationType: AppModel.lamgug?AnimationType2.slide_left:AnimationType2.slide_right,
                                  builder: (context) => MapViewPage(
                                      date_ar: _date_ar,
                                      date_en: _date_en,
                                      time_ar: _time_ar)
                              )
                              );
                            }else{

                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5,top: 5),
                            child: Text(Translations.of(context).button_agree , style: TextStyle(
                                fontSize: 18
                            ),
                            ),
                          ),
                          color: checkField? Theme.of(context).primaryColorDark :Colors.grey[400],
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
            }

            Widget lineDraw(){
              return Padding(
                padding: EdgeInsets.only(top: 3 ,left: 40 ,right: 40 ,bottom: 5),
                child: Divider(
                  color: Colors.grey[400],
                ),
              );
            }

            String _textLang(){
              return Translations.of(context).button_next;
            }
}
