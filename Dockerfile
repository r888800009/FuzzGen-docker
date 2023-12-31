FROM ubuntu:16.04 AS prepare

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LLVM_DIR /llvm-project/build
ENV FUZZGEN_HOME_DIR /FuzzGen

RUN apt-get update -y \
&&apt-get -y install locales \
&& sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
&& locale-gen --no-purge en_US.UTF-8

RUN apt-get update -y \
&& apt-get install gcc gdb curl vim python3 cmake make sudo file git build-essential libboost-all-dev \
llvm-6.0 zlib1g-dev -y

WORKDIR /
# fix build error
# RUN git clone https://github.com/HexHive/FuzzGen
RUN git clone https://github.com/irwincong/FuzzGen.git && cd /FuzzGen && git checkout patch-1

FROM prepare AS prepare2
WORKDIR /FuzzGen
RUN mkdir build && cd build && cmake .. && make -j$(nproc)

FROM prepare2 AS prepare-llvm
WORKDIR /
RUN git clone https://github.com/llvm/llvm-project && cd llvm-project && git checkout llvmorg-6.0.0
RUN cp -r /FuzzGen/src/preprocessor/ /llvm-project/clang/tools/fuzzgen/
RUN echo 'add_clang_subdirectory(fuzzgen)' >> /llvm-project/clang/tools/CMakeLists.txt
WORKDIR /llvm-project/
FROM prepare-llvm AS build-llvm
# we only need the fuzzgen-preprocessor, so ignore other error
RUN mkdir build && cd build && PATH=$PATH:/usr/lib/llvm-6.0/bin cmake ../clang && (make -j$(nproc) || ls /llvm-project/build/bin/fuzzgen-preprocessor)
