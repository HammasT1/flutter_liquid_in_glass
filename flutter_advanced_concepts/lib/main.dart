import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass of Liquid Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.deepPurple,
          inactiveTrackColor: Colors.deepPurple.withOpacity(0.3),
          thumbColor: Colors.deepPurpleAccent,
          overlayColor: Colors.deepPurple.withOpacity(0.2),
          valueIndicatorColor: Colors.deepPurple,
          valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          trackHeight: 6,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
      ),
      home: const GlassOfLiquidDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GlassOfLiquidDemo extends StatefulWidget {
  const GlassOfLiquidDemo({super.key});

  @override
  State<StatefulWidget> createState() => GlassOfLiquidDemoState();
}

class GlassOfLiquidDemoState extends State<GlassOfLiquidDemo> {
  double skew = .3;
  double fullness = .7;
  double ratio = .7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Glass of Liquid',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade100,
              Colors.orange.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    width: 320,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                      backgroundBlendMode: BlendMode.overlay,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: CustomPaint(
                      painter: GlassOfLiquid(
                        skew: .01 + skew * .4,
                        ratio: ratio,
                        fullness: fullness,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skew: ${(skew * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      value: skew,
                      onChanged: (newVal) {
                        setState(() {
                          skew = newVal;
                        });
                      },
                      divisions: 100,
                      label: '${(skew * 100).toInt()}%',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fullness: ${(fullness * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      value: fullness,
                      onChanged: (newVal) {
                        setState(() {
                          fullness = newVal;
                        });
                      },
                      divisions: 100,
                      label: '${(fullness * 100).toInt()}%',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ratio: ${(ratio * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      value: ratio,
                      onChanged: (newVal) {
                        setState(() {
                          ratio = newVal;
                        });
                      },
                      divisions: 100,
                      label: '${(ratio * 100).toInt()}%',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassOfLiquid extends CustomPainter {
  final double skew;
  final double ratio;
  final double fullness;

  GlassOfLiquid({required this.skew, required this.ratio, required this.fullness});

  @override
  void paint(Canvas canvas, Size size) {
    Paint glass = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    Paint milkTopPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Paint milkColor = Paint()
      ..color = const Color.fromARGB(255, 235, 235, 235)
      ..style = PaintingStyle.fill;
    Paint black = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    Rect top = Rect.fromLTRB(0, 0, size.width, size.width * skew);
    Rect bottom = Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height - size.width * 0.5 * skew * ratio),
        width: size.width * ratio,
        height: size.width * skew * ratio);

    Rect? liquidTop = Rect.lerp(bottom, top, fullness);

    Path cupPath = Path()
      ..moveTo(top.left, top.top + top.height * 0.5)
      ..arcTo(top, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * 0.5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(top.left, top.top + top.height * 0.5);

    Path liquidPath = Path()
      ..moveTo(liquidTop!.left, liquidTop.top + liquidTop.height * 0.5)
      ..arcTo(liquidTop, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * 0.5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(liquidTop.left, liquidTop.top + liquidTop.height * 0.5);

    canvas.drawPath(cupPath, glass);
    canvas.drawPath(liquidPath, milkColor);
    canvas.drawOval(liquidTop, milkTopPaint);
    canvas.drawPath(cupPath, black);
    canvas.drawOval(top, black);
  }

  @override
  bool shouldRepaint(covariant GlassOfLiquid oldDelegate) {
    return oldDelegate.fullness != fullness || oldDelegate.skew != skew || oldDelegate.ratio != ratio;
  }
}