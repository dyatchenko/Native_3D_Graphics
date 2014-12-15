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
        this.screenWidth = 320;
        this.screenHeight = 240;
    };

    function putPixel(x1, y1, color) {
        var widthRatio = canvas.width / camera.screenWidth;
        var heightRatio = canvas.height / camera.screenHeight;
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
        var heightRatio = canvas.height / camera.screenHeight;
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

    var wBuf = [];
    for (var i = -camera.screenHeight / 2; i <= camera.screenHeight / 2; i++) {
        wBuf[i] = [];
    }

    var scene = {
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
                var Sy = -Yk / Zk * h + camera.screenHeight / 2;

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
            Sy1 = Yd / (l + d) * h + camera.screenHeight / 2;

            xs = -(xt - x2);
            ys = -(yt - y2);
            zs = -(zt - z2);

            Zd = zs * Math.cos(a) + xs * Math.sin(a);
            Xd = zs * Math.sin(a) - xs * Math.cos(a);
            Yd = Zd * Math.sin(ay) - ys * Math.cos(ay);
            l = Zd * Math.cos(ay) + ys * Math.sin(ay);

            Sx2 = -Xd / (l + d) * h + camera.screenWidth / 2;
            Sy2 = Yd / (l + d) * h + camera.screenHeight / 2;

            if ((l1 + d > camera.minimumDistanceToDisplay) && (l + d > camera.minimumDistanceToDisplay))
                line(Sx1, Sy1, Sx2, Sy2, color);

            // magic with end of the arrow (>)
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
        // Works slow
        put3DTriangle: function (x1, y1, z1, x2, y2, z2, x3, y3, z3, color) {
            var
                i, id,
                xs, ys, zs,
                n,
                k1, k2, k3, k4,
                xn, xk,
                lk1, lk2, lk3, lk4,
                wn, wk, wd, wi,
                wk1, wk2, wk3,
                j1, j2, j3, j4,
                xrn, xrk;
            var m = [];
            var d = {
                sx: 0,
                sy: 0,
                rx: 0,
                ry: 0,
                rz: 0
            };

            for (i = 1; i <= 3; i++)
                m[i] = {
                    sx: 0,
                    sy: 0,
                    rx: 0,
                    ry: 0,
                    rz: 0
                };

            var a = camera.angleY;
            var ay = camera.angleX;
            var u = camera.angleZ;
            var h = camera.h;
            //var d = camera.d;
            var xt = camera.x;
            var yt = camera.y;
            var zt = camera.z;

            xs = -(xt - x1);
            ys = -(yt - y1);
            zs = -(zt - z1);

            var cosa = Math.cos(a);
            var sina = Math.sin(a);
            var sinay = Math.sin(ay);
            var cosay = Math.cos(ay);

            m[1].rz = zs * cosa + xs * sina;
            m[1].rx = -zs * sina + xs * cosa;
            m[1].ry = -m[1].rz * sinay + ys * cosay;
            m[1].rz = m[1].rz * cosay + ys * sinay + h;

            n = true;
            if (m[1].rz > 10) {
                m[1].sx = Math.round(m[1].rx / m[1].rz * h);
                m[1].sy = Math.round(m[1].ry / m[1].rz * h);
            } else n = false;

            xs = -(xt - x2);
            ys = -(yt - y2);
            zs = -(zt - z2);

            m[2].rz = zs * cosa + xs * sina;
            m[2].rx = -zs * sina + xs * cosa;
            m[2].ry = -m[2].rz * sinay + ys * cosay;
            m[2].rz = m[2].rz * cosay + ys * sinay + h;

            if (m[2].rz > 10) {
                m[2].sx = Math.round(m[2].rx / m[2].rz * h);
                m[2].sy = Math.round(m[2].ry / m[2].rz * h);
            } else n = false;

            xs = -(xt - x3);
            ys = -(yt - y3);
            zs = -(zt - z3);

            m[3].rz = zs * cosa + xs * sina;
            m[3].rx = -zs * sina + xs * cosa;
            m[3].ry = -m[3].rz * sinay + ys * cosay;
            m[3].rz = m[3].rz * cosay + ys * sinay + h;

            if (m[3].rz > 10) {
                m[3].sx = Math.round(m[3].rx / m[3].rz * h);
                m[3].sy = Math.round(m[3].ry / m[3].rz * h);
            } else n = false;

            if (n) {
///////////////////////////////////////////////////////////////////////////////////////////////}
                for (i = 1; i <= 2; i++)
                    for (id = 1; id <= 2; id++)
                        if (m[id].sy > m[id + 1].sy) {
                            d = m[id];
                            m[id] = m[id + 1];
                            m[id + 1] = d;
                        }

                if (m[1].sy == m[2].sy)
                    if (m[1].sx > m[2].sx) {
                        d = m[1];
                        m[1] = m[2];
                        m[2] = d;
                    }
                if (m[2].sy == m[3].sy)
                    if (m[2].sx < m[3].sx) {
                        d = m[2];
                        m[2] = m[3];
                        m[3] = d;
                    }
/////////////////////////////////////////////////////////////////////////////////////////////////}

                if (m[3].sy !== m[1].sy) {
                    k3 = (m[3].sx - m[1].sx) / (m[3].sy - m[1].sy);
                    k4 = m[1].sx - m[1].sy * k3;
                    if ((m[3].rz) !== (m[1].rz))
                        lk3 = (m[3].ry - m[1].ry) / (m[3].rz - m[1].rz);
                    if ((m[3].ry) != 0)
                        lk4 = 0.0025 / (m[3].ry - lk3 * m[3].rz);
                    lk3 = -lk4 * h * lk3;
                }

                if (m[1].sy !== m[2].sy) {
                    k1 = (m[2].sx - m[1].sx) / (m[2].sy - m[1].sy);
                    k2 = m[1].sx - m[1].sy * k1;
                    if ((m[2].rz) !== (m[1].rz))
                        lk1 = (m[2].ry - m[1].ry) / (m[2].rz - m[1].rz);
                    if ((m[2].ry) != 0)
                        lk2 = 0.0025 / (m[2].ry - lk1 * m[2].rz);
                    lk1 = -lk2 * h * lk1;

                    for (i = m[1].sy; i <= m[2].sy; i++) {
                        if ((i > -camera.screenHeight / 2) && (i < camera.screenHeight / 2)) {
                            xn = (i * k1 + k2);
                            xk = (i * k3 + k4);
                            wn = i * lk2 + lk1;
                            if (m[2].rz == m[1].rz)
                                wn = m[2].rz;
                            wk = i * lk4 + lk3;
                            if (m[1].rz == m[3].rz)
                                wk = m[3].rz;
                            if (xn > xk) {
                                xn = xn - xk;
                                xk = xk + xn;
                                xn = xk - xn;
                                wd = wn;
                                wn = wk;
                                wk = wd;
                            }

                            if (xn !== xk) {
                                j3 = 1 / (xn - xk);
                                j1 = (wn - wk) * j3;
                                j2 = (xn * wk - xk * wn) * j3;
                            }

                            for (id = Math.round(xn); id <= Math.round(xk); id++)
                                if ((id > -camera.screenWidth / 2) && (id < camera.screenWidth / 2)) {
                                    wi = (id * j1 + j2);
                                    if (xn == xk)  wi = wk;
                                    if ((!wBuf[i][id]) || (wBuf[i][id] < wi)) {
                                        putPixel(id + camera.screenWidth / 2, -i + camera.screenHeight / 2, color);
                                        wBuf[i][id] = wi;
                                    }
                                }
                        }
                    }
                }

                if (m[2].sy !== m[3].sy) {
                    k1 = (m[3].sx - m[2].sx) / (m[3].sy - m[2].sy);
                    k2 = m[2].sx - m[2].sy * k1;
                    if ((m[2].rz) !== (m[3].rz))
                        lk1 = (m[3].ry - m[2].ry) / (m[3].rz - m[2].rz);
                    if ((m[3].ry) != 0)
                        lk2 = 0.0025 / (m[3].ry - lk1 * m[3].rz);
                    lk1 = -lk2 * h * lk1;

                    for (i = m[2].sy; i <= m[3].sy; i++) {
                        if ((i > -camera.screenHeight / 2) && (i < camera.screenHeight / 2)) {
                            xn = (i * k1 + k2);
                            xk = (i * k3 + k4);
                            wn = i * lk2 + lk1;
                            if (m[2].rz == m[3].rz)
                                wn = m[2].rz;
                            wk = i * lk4 + lk3;
                            if (m[1].rz == m[3].rz)
                                wk = m[3].rz;
                            if (xn > xk) {
                                xn = xn - xk;
                                xk = xk + xn;
                                xn = xk - xn;
                                wd = wn;
                                wn = wk;
                                wk = wd;
                            }
                            if (xn !== xk) {
                                j3 = 1 / (xn - xk);
                                j1 = (wn - wk) * j3;
                                j2 = (xn * wk - xk * wn) * j3;
                            }
                            for (id = Math.round(xn); id <= Math.round(xk); id++)
                                if ((id > -camera.screenWidth / 2) && (id < camera.screenWidth / 2)) {
                                    wi = (id * j1 + j2);
                                    if (xn == xk)  wi = wk;
                                    if ((!wBuf[i][id]) || (wBuf[i][id] < wi)) {
                                        putPixel(id + camera.screenWidth / 2, -i + camera.screenHeight / 2, color);
                                        wBuf[i][id] = wi;
                                    }
                                }
                        }
                    }
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
            for (var i = -camera.screenHeight / 2; i <= camera.screenHeight / 2; i++) {
                wBuf[i] = [];
            }
        }
    }

    return Object.create(scene);
}

