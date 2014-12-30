import 'dart:html';
import 'dart:math';

class Stacker {


    int iteration = 1;

    double time = 200.0;
    double lastRun = 0.0;

    int stageWidth = 200;
    int stageHeight = 400;
    double figW, figH;

    int last = 0;
    int m = 10;
    int n = 20;

    List<int> length = [5, 5];
    int layer = 19;

    List<int> deltax = [0, 0];
    bool press = false;

    bool forward = true;
    bool start = true;

    CanvasElement stage;
    CanvasRenderingContext2D context2d;

    bool stop = false;

    Stacker(CanvasElement canvas) {
        stage = canvas;
        context2d = stage.context2D; // contexte
        Rectangle rect = stage.client; // format du html
        stageWidth = rect.width; // format du tableau
        stageHeight = rect.height;

        figW = stageWidth / m; // format des carreaux
        figH = stageHeight / n;
        _fillCanvas();
        window.onKeyDown.listen((KeyboardEvent e) {
            if (e.keyCode == KeyCode.SPACE && !stop) { // Si la touche "space" est uiliser mais la partie n'est pas terminé.
                press = true;
                if (layer > 12) { // accélération du mouvement
                    time = 150.0 - (iteration * iteration * 2 - iteration);
                } else {
                    time = time - 2.2;
                }

                iteration++;
                layer--;
                press = false;
                int tmp = check(); // réduction du curseur
                length[0] = length[1];
                length[1] = tmp;
                if (layer == -1) { // Quand le dernier niveau est atteint
                    window.alert("Félicitation, vous avez gagné!");
                    stop = true;
                }
                if (length[1] <= 0) {
                    window.alert("Partie terminé, vous avez atteint la ligne ${18 - layer}!");
                    stop = true;
                    return;
                }
                last = deltax[1];
                start = false;
            } // endif
        });
    }

    void _fillCanvas() {

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                var x = i * figW, y = j * figH, w = figW, h = figH;
                _drawRect(x, y, w, h);
            }
        }
        // end for
    }

    /**
     *
     */
    void _drawRect(x, y, w, h, {String fill: "#ffffff", String stroke: "#333333", double lineWidth: 0.5}) {
        context2d
            ..fillStyle = fill
            ..strokeStyle = stroke
            ..lineWidth = lineWidth
            ..beginPath()
            ..clearRect(x, y, w, h)
            ..rect(x, y, w, h)
            ..fill()
            ..stroke()
            ..closePath();
    }

    void run(double t) {
        if (stop) {
            return;
        }
        var doDraw = (t == 0.0) || ((t - lastRun) > time);
        if (doDraw) {
            print(" diff ${t - lastRun}");
            print("time $time");
            print("lastRun $lastRun");
            print("t $t");
            if (forward == true) {
                goForward();
            } else {
                goBack();
            }
            if (deltax[1] == m - length[1]) {
                forward = false;
            } else if (deltax[1] == 0) {
                forward = true;
            }
            draw();
            lastRun = t;
        }
        window.animationFrame.then((t) => run(t));

    }

    reset() {
        layer = 19;
        iteration = 1;
        time = 200.0;
        lastRun = 0.0;
        stageWidth = 200;
        stageHeight = 400;
        last = 0;
        length = [5, 5];
        deltax = [0, 0];
        press = stop = false;
        forward = start = true;
        _fillCanvas();
        return this;
    }

    int check() {
        if (start == true) {
            return length[1];
        } else if (last < deltax[1]) {
            if (deltax[1] + length[1] - 1 <= last + length[0] - 1) {
                return length[1];
            } else {
                return length[1] - ((deltax[1] + length[1]) - (last + length[0])).abs();
            }
        } else if (last > deltax[1]) {
            return length[1] - (deltax[1] - last).abs();
        } else {
            return length[1];
        }
    }

    void goForward() {
        deltax[0] = deltax[1];
        deltax[1]++;
    }

    void goBack() {
        deltax[0] = deltax[1];
        deltax[1]--;
    }

    void draw() {
        var j = layer, y = j * figH, w = figW, h = figH;
        for (int i = 0; i < length[1]; i++) {
            var x = (i + deltax[0]) * figW;
            _drawRect(x, y, w, h);
        }

        for (int i = 0; i < length[1]; i++) {
            var x = (i + deltax[1]) * figW;
            _drawRect(x, y, w, h, fill: "#00f");
        }
    }
}
