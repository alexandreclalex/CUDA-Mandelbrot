#pragma once

#include "IMandelbrotImpl.cuh"

class GpuMandelbrotImpl final : public IMandelbrotImpl {
public:
    GpuMandelbrotImpl();

    ~GpuMandelbrotImpl() override;

    std::chrono::microseconds GenerateImage(PPMImage& img) const override;

    std::string name() const override;
};


