import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SoundWavePainter extends CustomPainter {
  final List<double> soundValues;

  SoundWavePainter({required this.soundValues});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    final widthPerValue = size.width / soundValues.length;

    for (int i = 0; i < soundValues.length; i++) {
      final x = i * widthPerValue;
      final y = (1 - soundValues[i]) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SoundWavePainter oldDelegate) {
    return oldDelegate.soundValues != soundValues;
  }
}

class WaveformButton extends StatefulWidget {
  @override
  _WaveformButtonState createState() => _WaveformButtonState();
}

class _WaveformButtonState extends State<WaveformButton> {
  List<double> _soundValues = [];

  Future<void> _playSound() async {
    // Burada bir ses dosyasını çalabilirsiniz
    // ve dalga formunu alabilirsiniz.
    // Örnek olarak, rastgele değerlerle bir dalga formu oluşturuyoruz.

    final rng = Random();
    final values = <double>[];

    for (int i = 0; i < 200; i++) {
      values.add((rng.nextDouble() * 0.8) + 0.1);
    }

    setState(() {
      _soundValues = values;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _playSound,
            child: const Text('Ses çal'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 100,
            child: CustomPaint(
              painter: SoundWavePainter(soundValues: _soundValues),
            ),
          ),
        ],
      ),
    );
  }
}
