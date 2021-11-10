#pragma once

#include "IMandelbrotImpl.cuh"

class CpuMandelbrotImpl final : public IMandelbrotImpl {
public:
    CpuMandelbrotImpl();

    ~CpuMandelbrotImpl() override;

    std::chrono::microseconds GenerateImage(PPMImage& img) const override;

    std::string name() const override;

private:
    PPMPixel* m_colors;
};


