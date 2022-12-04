#!/bin/bash

# Update the package list and upgrade installed packages
sudo apt update
sudo apt upgrade -y

# Install the dependencies for OpenCV
sudo apt install -y build-essential cmake unzip pkg-config
sudo apt install -y libjpeg-dev libpng-dev libtiff-dev
sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt install -y libxvidcore-dev libx264-dev
sudo apt install -y libgtk-3-dev
sudo apt install -y libatlas-base-dev gfortran

# Create a temporary directory for building OpenCV
mkdir -p opencv-build && cd opencv-build

# Download the latest version of OpenCV from GitHub
wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/master.zip

# Unzip the downloaded files
unzip opencv.zip
unzip opencv_contrib.zip

# Set the build directory and install directory
BUILD_DIR="opencv-build"
INSTALL_DIR="/usr/local"

# Create a build directory and navigate to it
mkdir "$BUILD_DIR" && cd "$BUILD_DIR"

# Generate the makefile using CMake
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
      -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-master/modules \
      -D ENABLE_NEON=ON \
      -D ENABLE_VFPV3=ON \
      -D BUILD_TESTS=OFF \
      -D OPENCV_ENABLE_NONFREE=ON \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D BUILD_EXAMPLES=OFF ../opencv-master/

# Compile and install OpenCV
make -j4
sudo make install
sudo ldconfig

# Delete the temporary files
cd .. && rm -r opencv-build opencv-master opencv_contrib-master
