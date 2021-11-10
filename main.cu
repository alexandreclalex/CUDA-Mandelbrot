#include "PPM.cuh"
#include "impls/CpuMandelbrotImpl.cuh"
#include "impls/GpuMandelbrotImpl.cuh"
#include <cstdio>
#include <cmath>
#include <string>

static constexpr size_t MAX_ITERATION = 32;
static constexpr double X_MIN = -2.01;
static constexpr double X_MAX = 0.48;
static constexpr double Y_MIN = -1.13;
static constexpr double Y_MAX = 1.13;

int main(int argc, char* argv[]) {
    if (argc != 2 || strtol(argv[1], nullptr, 10) <= 0) {
        fprintf(stderr, "INVALID INPUT\nVALID INPUT IS A SINGLE POSITIVE INTEGER FOR THE IMAGE WIDTH\n");
        exit(1);
    }
    PPMImage img;
    img.x = strtol(argv[1], nullptr, 10);
    img.y = static_cast<long>(static_cast<double>(Y_MAX - Y_MIN) / static_cast<double>(X_MAX - X_MIN) *
                              static_cast<double>(img.x));
    img.data = new PPMPixel[img.x * img.y];

    CpuMandelbrotImpl cpu_impl;
    GpuMandelbrotImpl gpu_impl;
    auto us = cpu_impl.GenerateImage(img);

    printf("CPU generated %ld by %ld Mandelbrot set in %.6f seconds.\n", img.x, img.y,
           static_cast<double>(us.count()) / 1000000.0);
    writePPM("./out_cpu.ppm", &img);

    us = gpu_impl.GenerateImage(img);

    printf("GPU generated %ld by %ld Mandelbrot set in %.6f seconds.\n", img.x, img.y,
           static_cast<double>(us.count()) / 1000000.0);
    writePPM("./out_gpu.ppm", &img);

    delete[] img.data;
}
