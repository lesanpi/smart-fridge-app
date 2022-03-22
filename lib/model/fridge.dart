class Fridge {
  int temperature;
  String id;
  Fridge({required this.temperature, required this.id});

  bool sameFridge(Fridge fridge) => fridge.id == id;

  static Fridge empty() => Fridge(id: "", temperature: -127);
}
