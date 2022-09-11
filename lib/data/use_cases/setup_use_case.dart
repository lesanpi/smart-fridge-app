import 'dart:convert';

import 'package:wifi_led_esp8266/data/repositories/auth_repository.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/data/repositories/persistent_storage_repository.dart';
import 'package:wifi_led_esp8266/data/use_cases/auth_use_case.dart';
import 'package:wifi_led_esp8266/models/controller_configuration.dart';
import 'package:wifi_led_esp8266/models/device_configuration.dart';

import '../../consts.dart';
import 'package:http/http.dart' as http;

class SetupUseCase {
  SetupUseCase(
    this._persistentStorageRepository,
    this._localRepository,
    this._authUseCase,
  );
  final PersistentStorageRepository _persistentStorageRepository;
  final LocalRepository _localRepository;
  final AuthUseCase _authUseCase;

  Future<bool> configureDevice(
      DeviceConfiguration configuration, int type) async {
    final _token = await _persistentStorageRepository.getCurrentToken();
    final jsonData = jsonEncode({'type': type});
    print(configuration.toMap());
    final url = Uri.parse(Consts.httpLink + '/api/fridges');
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };
    // final response = await http.post(url, body: jsonData, headers: headers);

    // if (response.statusCode != 200) {
    //   return false;
    // }
    // print(response.body);
    // final responseDecoded = jsonDecode(response.body);
    // final userId = responseDecoded['user'];
    // final id = responseDecoded['id'];

    final userId = _authUseCase.currentUser!.id;
    _localRepository.configureController(configuration, userId);
    try {
      await _authUseCase.getCurrentUser();
    } catch (e) {}
    return true;
  }
}
