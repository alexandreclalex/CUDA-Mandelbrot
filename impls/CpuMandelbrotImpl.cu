#include "CpuMandelbrotImpl.cuh"
#include "../ColorImpl.cuh"

static constexpr size_t MAX_ITERATION = 32;
static constexpr double X_MIN = -2.01;
static constexpr double X_MAX = 0.48;
static constexpr double Y_MIN = -1.13;
static constexpr double Y_MAX = 1.13;

static unsigned int GetIterations(double x0, double y0) {
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

std::chrono::microseconds CpuMandelbrotImpl::GenerateImage(PPMImage& img) const {
    auto start = std::chrono::high_resolution_clock::now();
    for (long i = 0; i < img.x * img.y; i++) {
        double y0 = static_cast<double>(i) / static_cast<double>(img.x) / static_cast<double>(img.y) * (Y_MAX - Y_MIN) + Y_MIN;
        double x0 = static_cast<double>(i % img.x) / static_cast<double>(img.x) * (X_MAX - X_MIN) + X_MIN;
        img.data[i] = m_colors[GetIterations(x0, y0)];
    }
    auto end = std::chrono::high_resolution_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(end - start);
}

std::string CpuMandelbrotImpl::name() const {
    return "CPU";
}

CpuMandelbrotImpl::CpuMandelbrotImpl() {
    m_colors = new PPMPixel[MAX_ITERATION];
    for (int i = 0; i < MAX_ITERATION; i++) {
        m_colors[i] = GetColor((MAX_ITERATION - (double) i) / MAX_ITERATION);
    }
}

CpuMandelbrotImpl::~CpuMandelbrotImpl() {
    delete[] m_colors;
}
