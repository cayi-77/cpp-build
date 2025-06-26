FROM fedora
ARG VCPKG_REPO_TAG="master"

# install packages
RUN dnf install -y \
    g++ \
    make \
    cmake \
    git \
    ninja-build \
    wget \
    ca-certificates \
    curl \
    zip \
    unzip \
    tar \
    pkg-config \
    sudo \
    mold

WORKDIR /build-tools

RUN git clone https://github.com/Microsoft/vcpkg.git --branch $VCPKG_REPO_TAG

# try only use this on arm image.
ENV VCPKG_FORCE_SYSTEM_BINARIES=1

RUN ./vcpkg/bootstrap-vcpkg.sh -disableMetrics
RUN mkdir -p ~/bin
RUN ln -s /build-tools/vcpkg/vcpkg /bin/vcpkg

ENV CMAKE_TOOLCHAIN_FILE=/build-tools/vcpkg/scripts/buildsystems/vcpkg.cmake
ENV CMAKE_GENERATOR=Ninja

WORKDIR /workspace
RUN echo 'export PATH="~/bin:${PATH}"' >> ~/.bashrc
ENV PATH="~/bin:${PATH}"
ENV VCPKG_ROOT=/build-tools/vcpkg

RUN unlink /bin/sh && ln /bin/bash /bin/sh
