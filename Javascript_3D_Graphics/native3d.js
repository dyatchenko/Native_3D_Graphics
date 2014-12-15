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
        this.zoom = 10;
        this.minimumDistanceToDisplay = 10;
        this.screenWidth = 640;
        this.screenHeight = 480;
    };

    var widthRatio = canvas.width / camera.screenWidth;
    var heightRatio = canvas.height / camera.screenHeight;
    console.log(canvas.width, canvas.height);
    var halfWidth = canvas.width / 2;
    var halfHeight = canvas.height / 2;
    var pixelWidth = Math.round(widthRatio) + 1;
    var pixelHeight = Math.round(heightRatio) + 1;

    // Puts pixel with given coordinates on virtual screen.
    function putPixel(x1, y1, color) {
        var finalX = Math.round(x1 * widthRatio);
        var finalY = Math.round(-y1 * heightRatio);

        finalX += halfWidth;
        finalY += halfHeight;

        var previousStyle = context.fillStyle;

        context.fillStyle = color;
        context.fillRect(finalX, finalY, pixelWidth, pixelHeight);

        context.fillStyle = previousStyle;
    }

    // Puts line with given coordinates on virtual screen.
    function line(x1, y1, x2, y2, color) {
        var finalX1 = Math.round(x1 * widthRatio);
        var finalY1 = Math.round(-y1 * heightRatio);

        var finalX2 = Math.round(x2 * widthRatio);
        var finalY2 = Math.round(-y2 * heightRatio);

        finalX1 += halfWidth;
        finalY1 += halfHeight;
        finalX2 += halfWidth;
        finalY2 += halfHeight;

        var previousStyle = context.fillStyle;

        context.beginPath();
        context.moveTo(finalX1, finalY1);
        context.lineTo(finalX2, finalY2);
        context.strokeStyle = color;
        context.stroke();

        context.fillStyle = previousStyle;
    }

    function putText(x, y, text, size, color){
        size = typeof size !== 'undefined' ? size : 12;
        color = typeof color !== 'undefined' ? color : "black";

        var finalX = Math.round(x * widthRatio);
        var finalY = Math.round(-y * heightRatio);

        finalX += halfWidth;
        finalY += halfHeight;

        var previousStyle = context.fillStyle;
        context.fillStyle = color;
        context.font = "bold " + size + "px Arial";
        context.fillText(text, finalX, finalY);

        context.fillStyle = previousStyle;
    }

    var scene = {
        camera: camera,
        convert3DPointToVirtualScreenPoint: function (x, y, z) {
            var xs = x - camera.x;
            var ys = y - camera.y;
            var zs = z - camera.z;

            var cosAngY = Math.cos(camera.angleY);
            var sinAngY = Math.sin(camera.angleY);
            var cosAngX = Math.cos(camera.angleX);
            var sinAngX = Math.sin(camera.angleX);
            var cosAngZ = Math.cos(camera.angleZ);
            var sinAngZ = Math.sin(camera.angleZ);

            var Zd = zs * cosAngY + xs * sinAngY;
            var Xd = -zs * sinAngY + xs * cosAngY;
            var Yd = -Zd * sinAngX + ys * cosAngX;

            var Zk = Zd * cosAngX + ys * sinAngX;
            var Xk = Xd * cosAngZ - Yd * sinAngZ;
            var Yk = Xd * sinAngZ + Yd * cosAngZ;

            if (Zk - camera.zoom > camera.minimumDistanceToDisplay) {
                var Sx = Xk / (Zk - camera.zoom) * camera.h;
                var Sy = Yk / (Zk - camera.zoom) * camera.h;

                return {
                    x: Sx,
                    y: Sy
                };
            }

            return null;
        },
        put3DPixel: function (x, y, z, color) {
            var virtualScreenPoint = scene.convert3DPointToVirtualScreenPoint(x, y, z);
            if (virtualScreenPoint)
                putPixel(virtualScreenPoint.x, virtualScreenPoint.y, color);
        },
        put3DVector: function (x1, y1, z1, x2, y2, z2, color) {
            var virScrPos1 = scene.convert3DPointToVirtualScreenPoint(x1, y1, z1);
            var virScrPos2 = scene.convert3DPointToVirtualScreenPoint(x2, y2, z2);

            if (!virScrPos1 || !virScrPos2) return;

            line(virScrPos1.x, virScrPos1.y, virScrPos2.x, virScrPos2.y, color);

            var Sx1 = virScrPos1.x;
            var Sy1 = virScrPos1.y;
            var Sx2 = virScrPos2.x;
            var Sy2 = virScrPos2.y;

            // magic with end of the arrow (>)
            var ap;
            if (Sy1 != Sy2)  ap = Math.atan((Sx2 - Sx1) / (Sy1 - Sy2));
            else {
                if (Sx2 > Sx1)  ap = 4.71;
                if (Sx1 > Sx2)  ap = 1.57;
            }

            if ((Sy1 - Sy2) > 0) {
                line(Sx2, Sy2, Sx2 - 10 * Math.sin(ap - 0.35), Sy2 + 10 * Math.cos(ap - 0.35), color);
                line(Sx2, Sy2, Sx2 - 10 * Math.sin(ap + 0.35), Sy2 + 10 * Math.cos(ap + 0.35), color);
            }
            else {
                line(Sx2, Sy2, Sx2 + 10 * Math.sin(ap - 0.35), Sy2 - 10 * Math.cos(ap - 0.35), color);
                line(Sx2, Sy2, Sx2 + 10 * Math.sin(ap + 0.35), Sy2 - 10 * Math.cos(ap + 0.35), color);
            }
        },
        put3DText: function (x, y, z, text, size, color){
            var point = scene.convert3DPointToVirtualScreenPoint(x, y, z);
            if (!point) return;

            putText(point.x, point.y, text, size, color);
        },
        makeWorldSystem: function (size) {
            size = typeof size !== 'undefined' ? size : 100;
            scene.put3DVector(-size, 0, 0, size, 0, 0, "red");
            scene.put3DVector(0, -size, 0, 0, size, 0, "green");
            scene.put3DVector(0, 0, -size, 0, 0, size, "yellow");

            scene.put3DText(size, 0, 0, "X");
            scene.put3DText(0, size, 0, "Y");
            scene.put3DText(0, 0, size, "Z");
        },
        clearScreen: function () {
            context.clearRect(0, 0, canvas.width, canvas.height);
        },
        hideContextMenu: function () {
            canvas.oncontextmenu = function (e) {
                e.preventDefault();
            };
        },
        showCameraPosition: function (){
            var halfCamScreenWidth = camera.screenWidth / 2;
            var halfCamScreenHeight = camera.screenHeight / 2;

            var radToDeg = 180 / Math.PI;
            var angleX = (camera.angleX * radToDeg).toFixed(1);
            var angleY = (camera.angleY * radToDeg).toFixed(1);
            var angleZ = (camera.angleZ * radToDeg).toFixed(1);

            putText(-halfCamScreenWidth + 10, halfCamScreenHeight - 10, "CamX: " + camera.x.toFixed(1));
            putText(-halfCamScreenWidth + 10, halfCamScreenHeight - 20, "CamY: " + camera.y.toFixed(1));
            putText(-halfCamScreenWidth + 10, halfCamScreenHeight - 30, "CamZ: " + camera.z.toFixed(1));
            putText(-halfCamScreenWidth + 10, halfCamScreenHeight - 40, "AngleX: " + angleX);
            putText(-halfCamScreenWidth + 10, halfCamScreenHeight - 50, "AngleY: " + angleY);
            putText(-halfCamScreenWidth + 10, halfCamScreenHeight - 60, "AngleZ: " + angleZ);
            putText(-halfCamScreenWidth + 10, halfCamScreenHeight - 70, "Zoom: " + camera.zoom);
        }
    };

    return Object.create(scene);
}

