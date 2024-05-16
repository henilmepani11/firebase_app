import 'package:get_storage/get_storage.dart';

class GetStoragePref {
  final box = GetStorage();

  setLogin(String id) async {
    box.write('isLogin', id);
  }

  getLogin() {
    return box.read('isLogin');
  }

  clearLogin() async {
    box.remove('isLogin');
  }
}
