import 'package:intl/intl.dart';

class DatTim{

  int mathSumToDayDate(){
    var dbTimeKey = DateTime.now();
    var formatYear = DateFormat.y('en_US');
    var formatMonth = DateFormat.M('en_US');
    var formatDay = DateFormat.d('en_US');

    String year = formatYear.format(dbTimeKey);
    String mounth = formatMonth.format(dbTimeKey);
    String day = formatDay.format(dbTimeKey);

    int sum = (convertToInt(year)*356)+(convertToInt(mounth)*30)+convertToInt(day);

    print('date here :${sum}');
     return sum;
  }


  int convertToInt(String str){
    var _xx = int.parse(str);
    assert(_xx is int);
    return _xx;
  }

  double convertToDouble(String str){
    var _xx = double.parse(str);
    assert(_xx is double);
    return _xx;
  }


}