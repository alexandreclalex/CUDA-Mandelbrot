#include<stdio.h>
#include<stdlib.h>

typedef struct {
    unsigned char red, green, blue;
} PPMPixel;

typedef struct {
    long x, y;
    PPMPixel* data;
} PPMImage;

#define CREATOR "Alexandre Clavel"
#define RGB_COMPONENT_COLOR 255

static PPMPixel* points;

void writePPM(const char* filename, PPMImage* img) {
    FILE* fp;
    //open file for output
    fp = fopen(filename, "wb");
    if (!fp) {
        fprintf(stderr, "Unable to open file '%s'\n", filename);
        exit(1);
    }

    //write the header file
    //image format
    fprintf(fp, "P6\n");

    //comments
    fprintf(fp, "# Created by %s\n", CREATOR);

    //image size
    fprintf(fp, "%ld %ld\n", img->x, img->y);

    // rgb component depth
    fprintf(fp, "%d\n", RGB_COMPONENT_COLOR);

    // pixel data
    fwrite(img->data, 3 * img->x, img->y, fp);
    fclose(fp);
}

double lerp(double v0, double v1, double t) {
    return (1 - t) * v0 + t * v1;
}

PPMPixel lerp_ppm(PPMPixel a, PPMPixel b, double t) {
    PPMPixel out;
    out.red = lerp(a.red, b.red, t);
    out.green = lerp(a.green, b.green, t);
    out.blue = lerp(a.blue, b.blue, t);
    return out;
}

//PPMPixel get_color(double proportion) {
//    if (proportion == 0) {
//        PPMPixel result = {0, 0, 0};
//        return result;
//    }
//
//    PPMPixel point0 = {255, 255, 255};
//    PPMPixel point1 = {128, 0, 0};
//    PPMPixel point2 = {120, 81, 169};
//    PPMPixel point3 = {0, 0, 128};
//
//    PPMPixel a0 = lerp_ppm(point0, point1, proportion);
//    PPMPixel a1 = lerp_ppm(point1, point2, proportion);
//    PPMPixel a2 = lerp_ppm(point3, point3, proportion);
//
//    PPMPixel b0 = lerp_ppm(a0, a1, proportion);
//    PPMPixel b1 = lerp_ppm(a1, a2, proportion);
//
//    return lerp_ppm(b0, b1, proportion);
//}

int main(int argc, char* argv[]) {
    PPMImage img;
    img.x = 500;
    img.y = 500;

    img.data = (PPMPixel*) malloc(img.x * img.y * sizeof(PPMPixel));
    if (!img.data) {
        fprintf(stderr, "FAILED TO ALLOCATE %ld BYTES\n", img.x * img.y * sizeof(PPMPixel));
        exit(1);
    }


    for (int x = 0; x < img.x; x++) {
        for (int y = 0; y < img.y; y++) {
            img.data[y * img.x + x] = get_color(((double) y + x) / (img.y + img.x));
        }
    }

    writePPM("./colors.ppm", &img);
    free(img.data);
}
