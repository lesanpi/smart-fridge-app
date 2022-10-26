import 'package:flutter/material.dart';

import '../consts.dart';

class OutputCard extends StatelessWidget {
  const OutputCard(
      {super.key,
      required this.title,
      required this.onText,
      required this.offText,
      required this.output,
      required this.color,
      required this.icon});
  final String title;
  final String onText;
  final String offText;
  final bool output;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: Consts.defaultPadding / 2),
        Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(Consts.defaultPadding),
          // elevation: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(
                Radius.circular(Consts.borderRadius * 3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        output ? onText : offText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.9),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Icon(
                icon,
                size: 50,
                color: output ? Consts.primary.shade700 : Colors.black,
              )
            ],
          ),
        )
      ],
    );
  }
}
