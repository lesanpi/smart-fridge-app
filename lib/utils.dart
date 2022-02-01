import 'package:flutter/material.dart';

const primaryColor = Color(0xFF5290DC);
const lightColor = Color(0xFF9BD1FE);
const darkGrey = Color(0xFF1e1e1e);
const salmon = Color(0xFFC08192);
const lightYellow = Color(0xFFF4F19C);
const lightPurple = Color(0xFFC69CF4);
const purple = Color(0xFF8930E8);
const pink = Color(0xFFF49CC8);


/*

Container(
                    child: ledstatus ? Text("LED IS: ON") : Text("LED IS: OFF"),
                  ),
                  ElevatedButton(
                    //button to start scanning
                    onPressed: () {
                      //on button press
                      if (ledstatus) {
                        //if ledstatus is true, then turn off the led
                        //if led is on, turn off
                        sendcmd("poweroff");
                        ledstatus = false;
                      } else {
                        //if ledstatus is false, then turn on the led
                        //if led is off, turn on
                        sendcmd("poweron");
                        ledstatus = true;
                      }
                      setState(() {});
                    },
                    child:
                        ledstatus ? Text("TURN LED OFF") : Text("TURN LED ON"),
                  ),
*/