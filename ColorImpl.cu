#include "ColorImpl.cuh"

static double lerp(double v0, double v1, double t) {
    return (1 - t) * v0 + t * v1;
}

static PPMPixel lerp_ppm(PPMPixel a, PPMPixel b, double t) {
    PPMPixel out;
    out.red = static_cast<unsigned char>(round(lerp(a.red, b.red, t)));
    out.green = static_cast<unsigned char>(round(lerp(a.green, b.green, t)));
    out.blue = static_cast<unsigned char>(round(lerp(a.blue, b.blue, t)));
    return out;
}

PPMPixel GetColor(double proportion) {
    if (proportion == 0) {
        PPMPixel result = {0, 0, 0};
        return result;
    }

    PPMPixel point0 = {255, 255, 255};
    PPMPixel point1 = {128, 0, 0};
    PPMPixel point2 = {120, 81, 169};
    PPMPixel point3 = {0, 0, 128};

    PPMPixel a0 = lerp_ppm(point0, point1, proportion);
    PPMPixel a1 = lerp_ppm(point1, point2, proportion);
    PPMPixel a2 = lerp_ppm(point2, point3, proportion);

    PPMPixel b0 = lerp_ppm(a0, a1, proportion);
    PPMPixel b1 = lerp_ppm(a1, a2, proportion);

    return lerp_ppm(b0, b1, proportion);
}
