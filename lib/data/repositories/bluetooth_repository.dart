import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothRepository {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  late BluetoothConnection connection;

  // Is connected ?
  bool get isConnected => connection.isConnected;

  // Devices List
  List<BluetoothDevice> devicesList = [];
  final StreamController<List<BluetoothDevice>> _devicesStreamController =
      StreamController.broadcast();
  Stream<List<BluetoothDevice>> get devicesStream =>
      _devicesStreamController.stream;

  void init() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;
  }

  static Future<bool> requestEnableBluetooth() async {
    // Retrieving the current Bluetooth state
    final bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the Bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (bluetoothState == BluetoothState.STATE_OFF) {
      final success = await FlutterBluetoothSerial.instance.requestEnable();

      // await getPairedDevices();
      return success ?? false;
    }

    return true;
  }

  Future<bool> requestDisableBluetooth() async {
    // Retrieving the current Bluetooth state
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the Bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (bluetoothState == BluetoothState.STATE_OFF) {
      await bluetooth.requestDisable();
      // await getPairedDevices();
      return true;
    } else {
      // await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      // Store the [devices] list in the [devicesList] for accessing
      // the list outside this class
      devicesList = await bluetooth.getBondedDevices();
      _devicesStreamController.add(devicesList);
    } on PlatformException {
      print("Error");
    }
  }

  Future<void> connectTo(BluetoothDevice device) async {
    if (!isConnected) {
      connection = await BluetoothConnection.toAddress(device.address);
      bluetoothState = await bluetooth.state;
    }
  }

  void scanDevices() async {
    bluetooth.startDiscovery().listen((event) {
      print(event.device.address);
      print(event.device.name);
    });
  }
}
