//This program is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//along with this program.  If not, see <http://www.gnu.org/licenses/>.

function initialize3DScene(canvasId) {
    var canvas = document.getElementById(canvasId);
    var context = canvas.getContext("2d");

    var camera = new function () {
        this.x = 0;
        this.y = 0;
        this.z = 0;
        this.angleY = 0;
        this.angleX = 0;
        this.angleZ = 0;
        this.h = 400;
        this.d = 10;
        this.minimumDistanceToDisplay = 10;
        this.screenWidth = 640;
        this.screenHeigh = 480;
    };

    function putPixel(x1, y1, color) {
        var widthRatio = canvas.width / camera.screenWidth;
        var heightRatio = canvas.height / camera.screenHeigh;
        var finalX = Math.round(x1 * widthRatio);
        var finalY = Math.round(y1 * heightRatio);

        var pixelWidth = Math.round(widthRatio) + 1;
        var pixelHeight = Math.round(heightRatio) + 1;

        var previousStyle = context.fillStyle;
        context.fillStyle = color;

        context.fillRect(finalX, finalY, pixelWidth, pixelHeight);

        context.fillStyle = previousStyle;
    }

    function line(x1, y1, x2, y2, color) {
        var widthRatio = canvas.width / camera.screenWidth;
        var heightRatio = canvas.height / camera.screenHeigh;
        var finalX1 = Math.round(x1 * widthRatio);
        var finalY1 = Math.round(y1 * heightRatio);

        var finalX2 = Math.round(x2 * widthRatio);
        var finalY2 = Math.round(y2 * heightRatio);

        var previousStyle = context.fillStyle;

        context.beginPath();
        context.moveTo(finalX1, finalY1);
        context.lineTo(finalX2, finalY2);
        context.strokeStyle = color;
        context.stroke();

        context.fillStyle = previousStyle;
    }

    var scene = {
        context: context,
        canvas: canvas,
        camera: camera,
        put3DPixel: function (x, y, z, color) {
            var a = camera.angleY;
            var ay = camera.angleX;
            var u = camera.angleZ;
            var h = camera.h;
            var d = camera.d;

            var xs = x - camera.x;
            var ys = y - camera.y;
            var zs = z - camera.z;

            var Zd = zs * Math.cos(a) + xs * Math.sin(a);
            var Xd = -zs * Math.sin(a) + xs * Math.cos(a);
            var Yd = -Zd * Math.sin(ay) + ys * Math.cos(ay);

            var Zk = Zd * Math.cos(ay) + ys * Math.sin(ay);
            var Xk = Xd * Math.cos(u) - Yd * Math.sin(u);
            var Yk = Xd * Math.sin(u) + Yd * Math.cos(u);

            if (Zk + d > camera.minimumDistanceToDisplay) {
                var Sx = Xk / Zk * h + camera.screenWidth / 2;
                var Sy = -Yk / Zk * h + camera.screenHeigh / 2;

                putPixel(Sx, Sy, color);
            }
        },
        put3DVector: function (x1, y1, z1, x2, y2, z2, color) {
            var
                xs, ys, zs,
                l, Xd, Yd, Zd,
                Sx1, Sy1, Sx2, Sy2,
                ap, l1;
            var a = camera.angleY;
            var ay = camera.angleX;
            var u = camera.angleZ;
            var h = camera.h;
            var d = camera.d;
            var xt = camera.x;
            var yt = camera.y;
            var zt = camera.z;

            xs = -(xt - x1);
            ys = -(yt - y1);
            zs = -(zt - z1);

            Zd = zs * Math.cos(a) + xs * Math.sin(a);
            Xd = zs * Math.sin(a) - xs * Math.cos(a);
            Yd = Zd * Math.sin(ay) - ys * Math.cos(ay);
            l = Zd * Math.cos(ay) + ys * Math.sin(ay);
            l1 = l;

            Sx1 = -Xd / (l + d) * h + camera.screenWidth / 2;
            Sy1 = Yd / (l + d) * h + camera.screenHeigh / 2;

            xs = -(xt - x2);
            ys = -(yt - y2);
            zs = -(zt - z2);

            Zd = zs * Math.cos(a) + xs * Math.sin(a);
            Xd = zs * Math.sin(a) - xs * Math.cos(a);
            Yd = Zd * Math.sin(ay) - ys * Math.cos(ay);
            l = Zd * Math.cos(ay) + ys * Math.sin(ay);

            Sx2 = -Xd / (l + d) * h + camera.screenWidth / 2;
            Sy2 = Yd / (l + d) * h + camera.screenHeigh / 2;

            if ((l1 + d > camera.minimumDistanceToDisplay) && (l + d > camera.minimumDistanceToDisplay))
                line(Sx1, Sy1, Sx2, Sy2, color);

            if (Sy1 != Sy2)  ap = Math.atan((Sx2 - Sx1) / (Sy1 - Sy2))
            else {
                if (Sx2 > Sx1)  ap = 4.71;
                if (Sx1 > Sx2)  ap = 1.57;
            }

            if ((l1 + d > 50) && (l + d > 50)) {
                if ((Sy1 - Sy2) > 0) {
                    line(Sx2, Sy2, Sx2 - 10 * Math.sin(ap - 0.35), Sy2 + 10 * Math.cos(ap - 0.35), color);
                    line(Sx2, Sy2, Sx2 - 10 * Math.sin(ap + 0.35), Sy2 + 10 * Math.cos(ap + 0.35), color);
                }
                else {
                    line(Sx2, Sy2, Sx2 + 10 * Math.sin(ap - 0.35), Sy2 - 10 * Math.cos(ap - 0.35), color);
                    line(Sx2, Sy2, Sx2 + 10 * Math.sin(ap + 0.35), Sy2 - 10 * Math.cos(ap + 0.35), color);
                }
            }
        },
        makeWorldSystem: function () {
            scene.put3DVector(-100, 0, 0, 100, 0, 0, "red");
            scene.put3DVector(0, -100, 0, 0, 100, 0, "green");
            scene.put3DVector(0, 0, -100, 0, 0, 100, "yellow");
        },
        clearScreen: function () {
            context.clearRect(0, 0, canvas.width, canvas.height);
        }
    }

    return Object.create(scene);
}

