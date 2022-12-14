part of 'io3_krems_drawing.dart';

class IO3KremsSketch extends PPainter {
  // list of strokes
  List<List<PVector>> strokes = List<List<PVector>>.empty(growable: true);

  @override
  void setup() {
    fullScreen();
  }

  @override
  void draw() {
    background(Colors.white);
    noFill();

    for (var strk in strokes) {
      beginShape();

      for (var p in strk) {
        vertex(p.x, p.y);
      }
      strokeWeight(strk.last.strokeWidth);
      stroke(strk.last.color);
      endShape();
    }
  }

  @override
  void mousePressed() {
    strokes.add([
      PVector(
        mouseX,
        mouseY,
        0,
        _IO3KremsDrawingState.userSelectedStrokeWidth,
        _IO3KremsDrawingState.userSelectedColor,
      )
    ]);
  }

  @override
  void mouseDragged() {
    List<PVector> lastStroke = strokes.last;
    lastStroke.add(PVector(
      mouseX,
      mouseY,
      0,
      _IO3KremsDrawingState.userSelectedStrokeWidth,
      _IO3KremsDrawingState.userSelectedColor,
    ));
  }
}
