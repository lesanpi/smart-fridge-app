import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({Key? key, required this.connected}) : super(key: key);
  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            connected ? CupertinoIcons.wifi : CupertinoIcons.wifi_slash,
            color: Colors.black54,
            // color: connected
            //     ? Colors.lightGreenAccent.shade400
            //     : Colors.redAccent.shade400,
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
          Text(
            connected ? "Connected" : "Disconnected",
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
