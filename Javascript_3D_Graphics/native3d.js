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
    var canvasData = context.getImageData(0, 0, canvas.width, canvas.height);

    var camera = new function () {
        this.x = 0;
        this.y = 0;
        this.z = 0;
        this.h = 400;
        this.zoom = 10;
        this.minimumDistanceToDisplay = 10;
        this.screenWidth = 640;
        this.screenHeight = 480;

        var angleY = 0;
        var angleX = 0;
        var angleZ = 0;

        this.cosAngY = Math.cos(angleY);
        this.sinAngY = Math.sin(angleY);
        this.cosAngX = Math.cos(angleX);
        this.sinAngX = Math.sin(angleX);
        this.cosAngZ = Math.cos(angleZ);
        this.sinAngZ = Math.sin(angleZ);

        // Updates cos/sin constants every time when any angle changes
        function updateCosSinData() {
            camera.cosAngY = Math.cos(camera.angleY);
            camera.sinAngY = Math.sin(camera.angleY);
            camera.cosAngX = Math.cos(camera.angleX);
            camera.sinAngX = Math.sin(camera.angleX);
            camera.cosAngZ = Math.cos(camera.angleZ);
            camera.sinAngZ = Math.sin(camera.angleZ);
        }

        // angleY property
        Object.defineProperty(this, "angleY", {
            "get": function () {
                return angleY;
            }, "set": function (val) {
                angleY = val;
                updateCosSinData();
            }
        });

        // angleX property
        Object.defineProperty(this, "angleX", {
            "get": function () {
                return angleX;
            }, "set": function (val) {
                angleX = val;
                updateCosSinData();
            }
        });

        //angleZ property
        Object.defineProperty(this, "angleZ", {
            "get": function () {
                return angleZ;
            }, "set": function (val) {
                angleZ = val;
                updateCosSinData();
            }
        });
    };

    // Constants
    var widthRatio = canvas.width / camera.screenWidth;
    var heightRatio = canvas.height / camera.screenHeight;
    var halfWidth = canvas.width / 2;
    var halfHeight = canvas.height / 2;
    var pixelWidth = Math.round(widthRatio) + 1;
    var pixelHeight = Math.round(heightRatio) + 1;
    var knownColors = []; // Buffer of used colors
    var pixelCaptureMode = false;

    function convertSimpleColorToArgbColor(color) {
        var argbColor = {r: 255, g: 255, b: 255, a: 255};
        var lowerCaseColor = color.toLowerCase();
        if (typeof knownColors[lowerCaseColor] != 'undefined')
            argbColor = knownColors[lowerCaseColor];
        else {
            var hexColor = colorNameToHex(color).substring(1);
            argbColor = colorHexToRgb(hexColor);
            knownColors[lowerCaseColor] = argbColor;

            console.log(argbColor, color);
        }

        return argbColor;
    }

    // Puts pixel with given coordinates on virtual screen.
    function putPixel(x1, y1, color, useCapture) {
        var finalX = Math.round(x1 * widthRatio);
        var finalY = Math.round(-y1 * heightRatio);

        var argbColor = convertSimpleColorToArgbColor(color);

        finalX += halfWidth;
        finalY += halfHeight;

        if (finalX < 0 || finalX + pixelWidth >= canvas.width
            || finalY < 0 || finalY + pixelHeight >= canvas.height)return;

        // Simplest way to put pixel immediately
        if (!pixelCaptureMode) {
            var previousStyle = context.fillStyle;

            context.fillStyle = color;
            context.fillRect(finalX, finalY, pixelWidth, pixelHeight);

            context.fillStyle = previousStyle;
        }

        // Fastest way to put pixel on canvas
        // Scales pixel to canvas size
        for (var j = finalY; j < finalY + pixelHeight; j++) {
            var index = (finalX + j * canvas.width) * 4;

            if (index + 3 >= canvasData.data.length) return;

            for (var i = 0; i < pixelWidth; i++) {
                var position = i * 4 + index;
                canvasData.data[position + 0] = argbColor.r;
                canvasData.data[position + 1] = argbColor.g;
                canvasData.data[position + 2] = argbColor.b;
                canvasData.data[position + 3] = argbColor.a;
            }
        }
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

    // Puts text with given coordinates on virtual screen.
    function putText(x, y, text, size, color) {
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

        //canvasData = context.getImageData(0, 0, canvas.width, canvas.height);
    }

    var scene = {
        camera: camera,
        convert3DPointToVirtualScreenPoint: function (x, y, z) {
            var xs = x - camera.x;
            var ys = y - camera.y;
            var zs = z - camera.z;

            var Zd = zs * camera.cosAngY + xs * camera.sinAngY;
            var Xd = -zs * camera.sinAngY + xs * camera.cosAngY;
            var Yd = -Zd * camera.sinAngX + ys * camera.cosAngX;

            var Zk = Zd * camera.cosAngX + ys * camera.sinAngX;
            var Xk = Xd * camera.cosAngZ - Yd * camera.sinAngZ;
            var Yk = Xd * camera.sinAngZ + Yd * camera.cosAngZ;

            if (Zk - camera.zoom > camera.minimumDistanceToDisplay) {
                var inverse = camera.h / (Zk - camera.zoom);
                var Sx = Xk * inverse;
                var Sy = Yk * inverse;

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
        put3DText: function (x, y, z, text, size, color) {
            var point = scene.convert3DPointToVirtualScreenPoint(x, y, z);
            if (!point) return;

            putText(point.x, point.y, text, size, color);
        },
        makeWorldSystem: function (size) {
            size = typeof size !== 'undefined' ? size : 100;
            scene.put3DVector(0, 0, 0, size, 0, 0, "red");
            scene.put3DVector(0, 0, 0, 0, size, 0, "green");
            scene.put3DVector(0, 0, 0, 0, 0, size, "yellow");

            scene.put3DText(size, 0, 0, "X");
            scene.put3DText(0, size, 0, "Y");
            scene.put3DText(0, 0, size, "Z");
        },
        clearScreen: function () {
            context.clearRect(0, 0, canvas.width, canvas.height);
        },
        startPixelsCapture: function () {
            pixelCaptureMode = true;
            canvasData = context.getImageData(0, 0, canvas.width, canvas.height);
        },
        showCapturedPixels: function () {
            pixelCaptureMode = false;
            context.putImageData(canvasData, 0, 0);
        },
        showCameraPosition: function () {
            var halfCamScreenWidth = camera.screenWidth / 2;
            var halfCamScreenHeight = camera.screenHeight / 2;

            var radToDeg = 180 / Math.PI;
            var angleX = (camera.angleX * radToDeg).toFixed(1);
            var angleY = (camera.angleY * radToDeg).toFixed(1);
            var angleZ = (camera.angleZ * radToDeg).toFixed(1);

            putText(-halfCamScreenWidth + 5, halfCamScreenHeight - 10, "CamX: " + camera.x.toFixed(1));
            putText(-halfCamScreenWidth + 5, halfCamScreenHeight - 20, "CamY: " + camera.y.toFixed(1));
            putText(-halfCamScreenWidth + 5, halfCamScreenHeight - 30, "CamZ: " + camera.z.toFixed(1));
            putText(-halfCamScreenWidth + 5, halfCamScreenHeight - 40, "AngleX: " + angleX);
            putText(-halfCamScreenWidth + 5, halfCamScreenHeight - 50, "AngleY: " + angleY);
            putText(-halfCamScreenWidth + 5, halfCamScreenHeight - 60, "AngleZ: " + angleZ);
            putText(-halfCamScreenWidth + 5, halfCamScreenHeight - 70, "Zoom: " + camera.zoom);
        }
    };

    return Object.create(scene);
}

function colorHexToRgb(hex) {
    var bigint = parseInt(hex, 16);
    var r = (bigint >> 16) & 255;
    var g = (bigint >> 8) & 255;
    var b = bigint & 255;

    return {r: r, g: g, b: b, a: 255};
}

function colorNameToHex(colour) {
    var colours = {
        "aliceblue": "#f0f8ff",
        "antiquewhite": "#faebd7",
        "aqua": "#00ffff",
        "aquamarine": "#7fffd4",
        "azure": "#f0ffff",
        "beige": "#f5f5dc",
        "bisque": "#ffe4c4",
        "black": "#000000",
        "blanchedalmond": "#ffebcd",
        "blue": "#0000ff",
        "blueviolet": "#8a2be2",
        "brown": "#a52a2a",
        "burlywood": "#deb887",
        "cadetblue": "#5f9ea0",
        "chartreuse": "#7fff00",
        "chocolate": "#d2691e",
        "coral": "#ff7f50",
        "cornflowerblue": "#6495ed",
        "cornsilk": "#fff8dc",
        "crimson": "#dc143c",
        "cyan": "#00ffff",
        "darkblue": "#00008b",
        "darkcyan": "#008b8b",
        "darkgoldenrod": "#b8860b",
        "darkgray": "#a9a9a9",
        "darkgreen": "#006400",
        "darkkhaki": "#bdb76b",
        "darkmagenta": "#8b008b",
        "darkolivegreen": "#556b2f",
        "darkorange": "#ff8c00",
        "darkorchid": "#9932cc",
        "darkred": "#8b0000",
        "darksalmon": "#e9967a",
        "darkseagreen": "#8fbc8f",
        "darkslateblue": "#483d8b",
        "darkslategray": "#2f4f4f",
        "darkturquoise": "#00ced1",
        "darkviolet": "#9400d3",
        "deeppink": "#ff1493",
        "deepskyblue": "#00bfff",
        "dimgray": "#696969",
        "dodgerblue": "#1e90ff",
        "firebrick": "#b22222",
        "floralwhite": "#fffaf0",
        "forestgreen": "#228b22",
        "fuchsia": "#ff00ff",
        "gainsboro": "#dcdcdc",
        "ghostwhite": "#f8f8ff",
        "gold": "#ffd700",
        "goldenrod": "#daa520",
        "gray": "#808080",
        "green": "#008000",
        "greenyellow": "#adff2f",
        "honeydew": "#f0fff0",
        "hotpink": "#ff69b4",
        "indianred ": "#cd5c5c",
        "indigo": "#4b0082",
        "ivory": "#fffff0",
        "khaki": "#f0e68c",
        "lavender": "#e6e6fa",
        "lavenderblush": "#fff0f5",
        "lawngreen": "#7cfc00",
        "lemonchiffon": "#fffacd",
        "lightblue": "#add8e6",
        "lightcoral": "#f08080",
        "lightcyan": "#e0ffff",
        "lightgoldenrodyellow": "#fafad2",
        "lightgrey": "#d3d3d3",
        "lightgreen": "#90ee90",
        "lightpink": "#ffb6c1",
        "lightsalmon": "#ffa07a",
        "lightseagreen": "#20b2aa",
        "lightskyblue": "#87cefa",
        "lightslategray": "#778899",
        "lightsteelblue": "#b0c4de",
        "lightyellow": "#ffffe0",
        "lime": "#00ff00",
        "limegreen": "#32cd32",
        "linen": "#faf0e6",
        "magenta": "#ff00ff",
        "maroon": "#800000",
        "mediumaquamarine": "#66cdaa",
        "mediumblue": "#0000cd",
        "mediumorchid": "#ba55d3",
        "mediumpurple": "#9370d8",
        "mediumseagreen": "#3cb371",
        "mediumslateblue": "#7b68ee",
        "mediumspringgreen": "#00fa9a",
        "mediumturquoise": "#48d1cc",
        "mediumvioletred": "#c71585",
        "midnightblue": "#191970",
        "mintcream": "#f5fffa",
        "mistyrose": "#ffe4e1",
        "moccasin": "#ffe4b5",
        "navajowhite": "#ffdead",
        "navy": "#000080",
        "oldlace": "#fdf5e6",
        "olive": "#808000",
        "olivedrab": "#6b8e23",
        "orange": "#ffa500",
        "orangered": "#ff4500",
        "orchid": "#da70d6",
        "palegoldenrod": "#eee8aa",
        "palegreen": "#98fb98",
        "paleturquoise": "#afeeee",
        "palevioletred": "#d87093",
        "papayawhip": "#ffefd5",
        "peachpuff": "#ffdab9",
        "peru": "#cd853f",
        "pink": "#ffc0cb",
        "plum": "#dda0dd",
        "powderblue": "#b0e0e6",
        "purple": "#800080",
        "red": "#ff0000",
        "rosybrown": "#bc8f8f",
        "royalblue": "#4169e1",
        "saddlebrown": "#8b4513",
        "salmon": "#fa8072",
        "sandybrown": "#f4a460",
        "seagreen": "#2e8b57",
        "seashell": "#fff5ee",
        "sienna": "#a0522d",
        "silver": "#c0c0c0",
        "skyblue": "#87ceeb",
        "slateblue": "#6a5acd",
        "slategray": "#708090",
        "snow": "#fffafa",
        "springgreen": "#00ff7f",
        "steelblue": "#4682b4",
        "tan": "#d2b48c",
        "teal": "#008080",
        "thistle": "#d8bfd8",
        "tomato": "#ff6347",
        "turquoise": "#40e0d0",
        "violet": "#ee82ee",
        "wheat": "#f5deb3",
        "white": "#ffffff",
        "whitesmoke": "#f5f5f5",
        "yellow": "#ffff00",
        "yellowgreen": "#9acd32"
    };

    if (typeof colours[colour.toLowerCase()] != 'undefined')
        return colours[colour.toLowerCase()];

    return false;
}