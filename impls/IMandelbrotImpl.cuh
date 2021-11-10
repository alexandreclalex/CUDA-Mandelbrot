#pragma once

#include <chrono>
#include <string>
#include "../PPM.cuh"

class IMandelbrotImpl {
public:
    virtual ~IMandelbrotImpl() = default;

    virtual std::chrono::microseconds GenerateImage(PPMImage& img) const = 0;

    virtual std::string name() const = 0;
};