import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/local_repository.dart';
import 'package:wifi_led_esp8266/widgets/button_action.dart';
import 'package:wifi_led_esp8266/model/fridge_state.dart';
import 'package:wifi_led_esp8266/widgets/thermostat.dart';
import 'package:wifi_led_esp8266/consts.dart';

class FridgeWidget extends StatefulWidget {
  const FridgeWidget({Key? key, required this.fridgeState}) : super(key: key);
  final FridgeState fridgeState;
  @override
  State<FridgeWidget> createState() => _FridgeWidgetState();
}

class _FridgeWidgetState extends State<FridgeWidget> {
  late LocalRepository localRepository =
      RepositoryProvider.of<LocalRepository>(context);

  late double _minTemperatureSelected =
      widget.fridgeState.minTemperature.toDouble();
  late double _maxTemperatureSelected =
      widget.fridgeState.maxTemperature.toDouble();
  late bool _coordinatorMode = !widget.fridgeState.standalone;

  late final TextEditingController ssidStandaloneController =
      TextEditingController(
          text: widget.fridgeState.standalone ? widget.fridgeState.ssid : '');
  late final TextEditingController ssidCoordinatorController =
      TextEditingController(
          text: widget.fridgeState.standalone ? '' : widget.fridgeState.ssid);
  late final TextEditingController coordinatorPasswordController =
      TextEditingController();
  late final TextEditingController newPasswordController =
      TextEditingController();
  late final TextEditingController newPasswordConfirmationController =
      TextEditingController();
  late final TextEditingController currentPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Thermostat(temperature: widget.fridgeState.temperature),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonAction(
                onTap: () {
                  localRepository.toggleLight(widget.fridgeState.id);
                },
                selected: widget.fridgeState.light,
                iconData: Icons.lightbulb,
                description: 'Luz',
              ),
              const SizedBox(
                width: 40,
              ),
              ButtonAction(
                onTap: () {},
                selected: widget.fridgeState.compressor,
                iconData: Icons.ac_unit_outlined,
                description: 'Compresor',
              ),
              const SizedBox(
                width: 40,
              ),
              ButtonAction(
                onTap: () {},
                selected: widget.fridgeState.door,
                iconData: Icons.door_front_door_outlined,
                description: 'Puerta',
              )
            ],
          ),
          const SizedBox(height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Volver a valores por defecto"),
                ),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  const Text(
                    "Temperatura mínima",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _minTemperatureSelected.toInt() !=
                            widget.fridgeState.minTemperature
                        ? () {
                            localRepository.setMinTemperature(
                              widget.fridgeState.id,
                              _minTemperatureSelected.toInt(),
                            );
                          }
                        : null,
                    child: Text("Guardar"),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _minTemperatureSelected.toInt().toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      min: -20,
                      max: _maxTemperatureSelected - 1,
                      value: _minTemperatureSelected,
                      onChanged: (value) {
                        setState(() {
                          _minTemperatureSelected = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Temperatura máxima",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _maxTemperatureSelected.toInt() !=
                            widget.fridgeState.maxTemperature
                        ? () {
                            localRepository.setMaxTemperature(
                              widget.fridgeState.id,
                              _maxTemperatureSelected.toInt(),
                            );
                          }
                        : null,
                    child: Text("Guardar"),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _maxTemperatureSelected.toInt().toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      min: _minTemperatureSelected + 1,
                      max: 30,
                      value: _maxTemperatureSelected,
                      onChanged: (value) {
                        setState(() {
                          _maxTemperatureSelected = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Modo coordinado",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  CupertinoSwitch(
                    value: _coordinatorMode,
                    activeColor: Consts.primary,
                    onChanged: (value) {
                      setState(() {
                        _coordinatorMode = value;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 12),
              if (_coordinatorMode)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(children: [
                    TextField(
                      controller: ssidCoordinatorController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'SSDI del Coordinador',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: coordinatorPasswordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Contraseña del Coordinador',
                      ),
                    )
                  ]),
                ),
              if (!_coordinatorMode)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(children: [
                    TextField(
                      controller: ssidStandaloneController,
                      decoration: InputDecoration(
                        // border: Theme.of(context).inputDecorationTheme.border,
                        hintText: 'SSDI de la nevera',
                      ),
                    ),
                    // const SizedBox(height: 12),
                    // TextField(
                    //   controller: newPasswordController,
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Contraseña del Wifi',
                    //   ),
                    //   obscureText: true,
                    //   keyboardType: TextInputType.text,
                    // )
                  ]),
                ),
              const SizedBox(height: 25 / 2),
              ElevatedButton(
                onPressed: _ssidOnTap(),
                child: Text("EJECUTAR CAMBIOS"),
              ),
            ],
          ),
          const SizedBox(height: 75),
          OutlinedButton(
            onPressed: () {
              localRepository.client.disconnect();
            },
            child: const Text(
              "DESCONECTARSE",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Function()? _ssidOnTap() {
    if (!_coordinatorMode) {
      if (ssidStandaloneController.text == widget.fridgeState.ssid &&
          ssidStandaloneController.text.isNotEmpty) {
        return null;
      }

      return _setStandaloneMode;
    }

    if (ssidCoordinatorController.text.isNotEmpty) return _setCoordinatorMode;

    return null;
  }

  void _setStandaloneMode() {
    localRepository.setStandaloneMode(
        widget.fridgeState.id, ssidStandaloneController.text);
  }

  void _setCoordinatorMode() {
    localRepository.setCoordinatorMode(widget.fridgeState.id,
        ssidCoordinatorController.text, coordinatorPasswordController.text);
  }
}
