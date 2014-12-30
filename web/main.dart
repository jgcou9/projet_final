import 'dart:html';
import 'stacker.dart';

void main() {
  CanvasElement canvas = querySelector('#stacker');
  Stacker app = new Stacker(canvas);
  app.run(0.0);
  querySelector("#run").onClick.listen((MouseEvent e){
    e.preventDefault();
    app.reset().run(0.0);
    (e.target as ButtonElement).blur();
  });
  print("end main");
}

