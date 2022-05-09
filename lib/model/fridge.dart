class Fridge {
  String id;
  int temperature;
  bool standaloneMode = false;
  bool light = false;
  bool compressor = false;
  late DateTime lastDateTime;
  double maxTemperature = 20;
  double minTemperature = -10;
  //FridgeStatus status = FridgeStatus.disconnected;

  Fridge({required this.temperature, required this.id});

  bool sameFridge(Fridge fridge) => fridge.id == id;

  static Fridge empty() => Fridge(id: "", temperature: -127);
}
