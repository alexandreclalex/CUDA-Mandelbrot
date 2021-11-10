#include <cmath>

#include "GpuMandelbrotImpl.cuh"
#include "../ColorImpl.cuh"

static constexpr size_t MAX_ITERATION = 32;
static constexpr double X_MIN = -2.01;
static constexpr double X_MAX = 0.48;
static constexpr double Y_MIN = -1.13;
static constexpr double Y_MAX = 1.13;

__constant__ PPMPixel d_colors[MAX_ITERATION]; // device array in constant memory

__device__ static unsigned int GetIterations(double x0, double y0) {
    double x = 0;
    double y = 0;
    int iteration = 0;
    while (x * x + y * y <= 4 && iteration < MAX_ITERATION) {
        double x_temp = x * x - y * y + x0;
        y = 2 * x * y + y0;
        x = x_temp;
        iteration++;
    }
    return iteration;
}

GpuMandelbrotImpl::GpuMandelbrotImpl() {
    auto* colors = new PPMPixel[MAX_ITERATION];
    for (int i = 0; i < MAX_ITERATION; i++) {
        colors[i] = GetColor((MAX_ITERATION - (double) i) / MAX_ITERATION);
    }
    cudaMemcpyToSymbol(d_colors, colors, MAX_ITERATION * sizeof(PPMPixel));
    delete[] colors;
}

GpuMandelbrotImpl::~GpuMandelbrotImpl() = default;

__global__ void mandelbrot(PPMImage img) {
    size_t row = (blockIdx.y * blockDim.y) + threadIdx.y;
    size_t col = (blockIdx.x * blockDim.x) + threadIdx.x;
    if ((row < img.y) && (col < img.x)) {
        size_t idx = row * img.x + col;
        double y0 = (double) (idx / img.x) / img.y * (Y_MAX - Y_MIN) + Y_MIN;
        double x0 = (double) (idx % img.x) / img.x * (X_MAX - X_MIN) + X_MIN;
        img.data[idx] = d_colors[GetIterations(x0, y0)];
    }
}

std::chrono::microseconds GpuMandelbrotImpl::GenerateImage(PPMImage& img) const {
    // GPU implementation
    cudaEvent_t start, stop; //declare a start and stop event
    cudaEventCreate(&start); //create both events
    cudaEventCreate(&stop);

    size_t size = img.x * img.y * sizeof(PPMPixel);

    // device image
    PPMImage d_img;
    d_img.x = img.x;
    d_img.y = img.y;
    cudaMalloc(&d_img.data, size);

    dim3 dimBlock(32, 32);
    dim3 dimGrid(std::ceil((float) d_img.x / 32), std::ceil((float) d_img.y / 32), 1);

    cudaEventRecord(start);
    mandelbrot<<<dimGrid, dimBlock>>>(d_img);
    cudaEventRecord(stop);

    cudaMemcpy(img.data, d_img.data, size, cudaMemcpyDeviceToHost);
    cudaEventSynchronize(stop);

    float milliseconds = 0; //declare a variable to store runtime
    cudaEventElapsedTime(&milliseconds, start, stop); //get the elapsed time

    return std::chrono::microseconds(static_cast<size_t>(milliseconds * std::chrono::microseconds::period::den /
                                                         std::chrono::milliseconds::period::den));
}

std::string GpuMandelbrotImpl::name() const {
    return "GPU Implementation";
}
