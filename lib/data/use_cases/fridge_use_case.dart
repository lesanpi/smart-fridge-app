import 'dart:convert';

import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/persistent_storage_repository.dart';
import 'package:wifi_led_esp8266/data/use_cases/auth_use_case.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_led_esp8266/models/temperature_stat.dart';

class FridgeUseCase {
  const FridgeUseCase(this._authUseCase, this._persistentStorageRepository);
  final AuthUseCase _authUseCase;
  final PersistentStorageRepository _persistentStorageRepository;

  Future<List<TemperatureStat>> getFridgeTemperatures(String fridgeId) async {
    final _token = await _persistentStorageRepository.getCurrentToken();

    final url =
        Uri.parse(Consts.httpLink + '/api/fridges/temperatures/' + fridgeId);
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Error occurred');
    }
    Iterable responseDecoded = json.decode(response.body);

    // final userId = responseDecoded['user'];
    // final id = responseDecoded['id'];
    // _localRepository.configureController(configuration, userId, id);

    final stats = List<TemperatureStat>.from(responseDecoded.map((element) {
      final stat = TemperatureStat.fromMap(element);
      return stat;
    }));
    // final stats = List<TemperatureStat>.from(
    //     responseDecoded.map((stat) => TemperatureStat.fromJson(stat)));

    return stats;
  }

  Future<bool> deleteFridge(String fridgeId) async {
    final _token = await _persistentStorageRepository.getCurrentToken();

    final url = Uri.parse(Consts.httpLink + '/api/fridges/' + fridgeId);
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    try {
      final response = await http.delete(url, headers: headers);

      await _authUseCase.getCurrentUser();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
