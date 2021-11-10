#include "PPM.cuh"
#include <cstdio>

static constexpr char const* CREATOR = "Alexandre Clavel";
static constexpr unsigned int RGB_COMPONENT_COLOR = 255;

void writePPM(char const* filename, PPMImage* img) {
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
