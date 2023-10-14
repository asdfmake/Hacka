import 'package:http/http.dart' as http;

//parse cvs file
import 'package:csv/csv.dart';

class ApiCaller{
  Future<String> getBasicData() async{
    try {
      return (await http.get(Uri.parse("http://localhost:3000/"))).body;
    } catch (e) {
      print(e);
    }
    return "jbg";
  }

  Future<String> nesto() async{
    var csvFile = null;
    try {
      csvFile = (await http.get(Uri.parse("http://localhost:3000/getCsv"))).body;
    } catch (e) {
      print(e);
    }

    if(csvFile != null){
      final List<List<dynamic>> csvTable = CsvToListConverter().convert(csvFile);

      print(csvTable[3][2]);
      /* for (final row in csvTable) {
        for (final cell in row) {
          print(cell);
        }
      } */
    }
    return "jbg";
  }
  
}