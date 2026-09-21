import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MaterialApp(home: DrumPadPage(), debugShowCheckedModeBanner: false));
}

class DrumPadPage extends StatelessWidget {
  final MidiCommand _midiCommand = MidiCommand();

  void sendMIDI(int note, int velocity) {
    _midiCommand.sendData(Uint8List.fromList([0x90, note, velocity]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemCount: 8,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onPanDown: (details) {
                    double y = details.localPosition.dy;
                    // Velocity 0 to 127 (Niche low, upar high)
                    int vel = (127 - (y / 150 * 127).clamp(0, 127)).toInt();
                    sendMIDI(60 + index, vel);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white10),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(width: 60, color: Color(0xFF111111), child: Center(child: RotatedBox(quarterTurns: 1, child: Text("MORE", style: TextStyle(color: Colors.white24, fontSize: 10))))),
        ],
      ),
    );
  }
}
