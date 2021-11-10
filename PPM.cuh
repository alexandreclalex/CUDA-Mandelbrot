#pragma once

typedef struct {
    unsigned char red, green, blue;
} PPMPixel;

typedef struct {
    long x, y;
    PPMPixel* data;
} PPMImage;

void writePPM(char const* filename, PPMImage* img);
