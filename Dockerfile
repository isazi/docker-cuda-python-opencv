#
# Darknet
#

# Ubuntu 18.04 + CUDA 10.1
FROM nvidia/cuda:10.1-devel-ubuntu18.04
ARG DEBIAN_FRONTEND=noninteractive

# Install base system
WORKDIR /
RUN apt-get -qq -y update && apt-get -qq -y dist-upgrade
RUN apt-get -qq -y update && apt-get -qq -y install \
	build-essential \
	git \
    python3 \
    python3-opencv \
    python3-pip \
    libopencv-dev \
    libcudnn7-dev \
    && apt-get clean
RUN rm -rf /var/lib/apt/lists/*
ENV LD_LIBRARY_PATH="/usr/local/cuda-10.1/compat:${LD_LIBRARY_PATH}"

# Install Darknet with CUDA, CUDNN and OpenCV
WORKDIR /opt
ENV GPU=1
ENV CUDNN=1
ENV OPENCV=1
ENV OPENMP=1
ENV LIBSO=1
RUN git clone https://github.com/AlexeyAB/darknet.git
WORKDIR /opt/darknet
RUN make -e -j
RUN cp libdarknet.so /usr/local/lib && ldconfig
RUN cp darknet /usr/local/bin
ENV PYTHONPATH="/opt/darknet:${PYTHONPATH}"

# Final state
WORKDIR /
