import 'dart:developer';

import 'package:get_storage/get_storage.dart';

final box = GetStorage();

read(String storageName){
  dynamic result = box.read(storageName) ?? "";
  return result;
}

write(String storageName,dynamic value){
  box.write(storageName, value);
}

remove(String storageName){
  box.remove(storageName);
}

clearAllData(){
  log('\x1B[31mAlert => Clearing all cached data\x1B[0m');
  var passcodeStatus = read('passcode');
  var userId = read('userId');
  box.erase();
  if(passcodeStatus == false) {
    write('passcode', passcodeStatus);
    write('userId', userId);
  }
}
