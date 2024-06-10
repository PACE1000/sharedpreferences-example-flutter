import 'package:shared_preferences/shared_preferences.dart';


class ValueManager{
  static const String nilai = 'Nilai';
  static const String _waktu = 'timestamp';

  Future<void> saveValue(String value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(nilai, value);
    await prefs.setInt(_waktu, DateTime.now().millisecondsSinceEpoch);
  }

  Future<String?> getValue() async{
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_waktu);
    if(timestamp !=null){
      final now = DateTime.now().millisecondsSinceEpoch;
      const waktu = 5*60*1000;
      
      if(now - timestamp >= waktu){
        await _deletevalue();
        return null;
      }
    }
    return prefs.getString(nilai);
  }

  Future<void> _deletevalue() async {
    final prefs= await SharedPreferences.getInstance();
    await prefs.remove(nilai);
    await prefs.remove(_waktu);
  }

  Future<void> checkandDeleteValue() async{
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_waktu);
    if(timestamp != null){
      final now = DateTime.now().millisecondsSinceEpoch;
      const waktu = 5*60*1000;
      if(now - timestamp >= waktu){
        await _deletevalue();
      }
    }

  }
}