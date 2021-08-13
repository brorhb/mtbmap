import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mtbmap/LocationProvider.dart';
import 'package:provider/provider.dart';

class Compass extends StatelessWidget {
  const Compass({Key? key, required this.onTap, this.heading})
      : super(key: key);
  final double? heading;
  final Function(int) onTap;
  final double size = 40.0;

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return StreamBuilder<Position>(
        stream: locationProvider.locationStream,
        builder: (context, AsyncSnapshot snapshot) {
          int direction = heading != null
              ? heading!.toInt()
              : snapshot.data?.heading?.toInt() ?? 0;
          return Transform.rotate(
            angle: -(direction * pi / 180),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: InkWell(
                onTap: () {
                  onTap(direction);
                },
                child: SizedBox(
                  height: size,
                  width: size,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size / 5,
                        width: size / 5,
                        child: CustomPaint(
                          painter: _TrianglePainter(
                            strokeWidth: 2,
                            paintingStyle: PaintingStyle.fill,
                            strokeColor: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        "N",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  _TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
