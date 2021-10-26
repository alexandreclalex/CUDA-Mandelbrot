#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<math.h>
typedef struct {
    unsigned char red,green,blue;
} PPMPixel;

typedef struct {
    long x, y;
    PPMPixel *data;
} PPMImage;

#define CREATOR "Alexandre Clavel"
#define RGB_COMPONENT_COLOR 255
#define MAX_ITERATION 32
#define X_MIN -2.01
#define X_MAX 0.48
#define Y_MIN -1.13
#define Y_MAX 1.13

void writePPM(const char *filename, PPMImage *img)
{
    FILE *fp;
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
    fprintf(fp, "# Created by %s\n",CREATOR);

    //image size
    fprintf(fp, "%ld %ld\n",img->x,img->y);

    // rgb component depth
    fprintf(fp, "%d\n",RGB_COMPONENT_COLOR);

    // pixel data
    fwrite(img->data, 3 * img->x, img->y, fp);
    fclose(fp);
}

PPMPixel get_color(int iteration){
    double percent = 1 - ((double) iteration / MAX_ITERATION);
    PPMPixel result;
    result.red = RGB_COMPONENT_COLOR * percent;
    result.blue = RGB_COMPONENT_COLOR * percent;
    result.green = RGB_COMPONENT_COLOR * percent;
    return result;
}

int get_iterations(double x0, double y0){
    double x = 0;
    double y = 0;
    int iteration = 0;
    while (x*x + y*y <= 4 && iteration < MAX_ITERATION){
        double x_temp = x * x - y * y + x0;
        y = 2*x*y + y0;
        x = x_temp;
        iteration++;
    }
    return iteration;
}

int main(int argc, char* argv[]) {
    if(argc != 2 || atoi(argv[1]) <= 0){
        fprintf(stderr, "INVALID INPUT\nVALID INPUT IS A SINGLE POSITIVE INTEGER FOR THE IMAGE WIDTH\n");
        exit(1);
    }
    PPMImage img;
    img.x = atoi(argv[1]);
    img.y = (Y_MAX - Y_MIN)/(X_MAX - X_MIN) * img.x;


    img.data = (PPMPixel *)malloc(img.x * img.y * sizeof(PPMPixel));
    if(!img.data){
        fprintf(stderr, "FAILED TO ALLOCATE %ld BYTES\n", img.x * img.y * sizeof(PPMPixel));
        exit(1);
    }

    PPMPixel* colors = (PPMPixel *)malloc(MAX_ITERATION * sizeof(PPMPixel));
    for(int i = 0; i<MAX_ITERATION; i++){
        colors[i] = get_color(i);
    }

    clock_t start = clock();
    for(long i = 0; i < img.x * img.y; i++){
        double y0 = (double)(i / img.x)/img.y * (Y_MAX - Y_MIN) + Y_MIN;
        double x0 = (double)(i % img.x)/img.x * (X_MAX - X_MIN) + X_MIN;
        img.data[i] = colors[get_iterations(x0, y0)];
    }
    clock_t end = clock();
    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Generated %ld by %ld Mandelbrot set in %f seconds.\n", img.x, img.y, time_spent);
    writePPM("./out.ppm", &img);
    free(img.data);
}
