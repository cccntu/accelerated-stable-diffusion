# Accelerated Stable Diffusion

|                                       | Latency (1 image) | Max Batch Size | Max Throughput\*\* |
|---------------------------------------|-------------------|----------------|----------------|
| NVIDIA GeForce RTX 3090               | 2.76              | >=128          | 28.58          |
| NVIDIA GeForce RTX 3080               | 3.14              | >=48           | 24.88          |
| NVIDIA A100 80GB PCIe (unoptimized\*)   | 3.74              | 28             | 26.30          |
| NVIDIA GeForce RTX 3090 (unoptimized\*) | 4.84              | 4              |                |
| NVIDIA GeForce RTX 3080 (unoptimized\*) | 5.59              | 1              |                |

* (*) These are numbers reported by Lambda Labs. [blog](https://lambdalabs.com/blog/inference-benchmark-stable-diffusion/), [code](https://github.com/LambdaLabsML/lambda-diffusers)
* (**) The max throughput is not always achieved with Max Batch Size

This README is a work in progress. But the code is ready to use.

## Description

This repository contains the Dockerfile and instructions to build an accelerated stable diffusion environment.

## Usage (Short Version)
* Install Docker
* Install nvidia-docker2
* set docker default runtime to nvidia
* Clone this repository
* Make sure `CompVis/stable-diffusion-v1-4` is linked in `~/models/CompVis/stable-diffusion-v1-4`
* Build the docker image with `make build`
* Run the docker image with `make run`
* (Optional) Run the test with `make test` or `make latency`
  * This will run the example in the `scripts` folder

## Note
* You can use `USE_MEMORY_EFFICIENT_ATTENTION=1 python scripts/benchmark.py --samples 1,2,4` to test different batch sizes.
