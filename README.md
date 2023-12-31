# FuzzGen-docker
[HexHive/FuzzGen](https://github.com/HexHive/FuzzGen)

build
```
# for debug
docker build . -t fuzzgen-prepare --target prepare
docker run -it --rm fuzzgen-prepare

# debug llvm
docker build . -t fuzzgen-prepare-llvm --target prepare-llvm
docker run -it --rm fuzzgen-prepare-llvm

# build all
docker build . -t fuzzgen
docker run -it -v $(pwd):/work --rm fuzzgen
```

note: use for android must patch `FuzzGen/src/compose.h` before build docker

- fuzzgen llvm location: `LLVM_SRC=/llvm-project`
