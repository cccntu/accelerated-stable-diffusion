import time
from pathlib import Path

import torch
from diffusers import StableDiffusionPipeline

# CHANGE THIS TO YOUR PATH
path = Path("~/models/stable-diffusion-v1-4").expanduser()
# path = "CompVis/stable-diffusion-v1-4"


pipe = StableDiffusionPipeline.from_pretrained(
    path, revision="fp16", torch_dtype=torch.float16, use_auth_token=True
)


def null_safety_checker(images, *args, **kwargs):
    return images, None


pipe.safety_checker = null_safety_checker


def null_feature_extractor(images, return_tensors="pt", **kwargs):
    class Dummy:
        def __init__(self):
            self.pixel_values = torch.zeros((1,))

        def to(self, *args, **kwargs):
            return self

    return Dummy()


pipe.feature_extractor = null_feature_extractor
del pipe.vae.encoder
pipe = pipe.to("cuda")
# with torch.inference_mode(), torch.autocast("cuda"):
# auto-cast slows down the code, so we don't use it, some manual casting is used in the code
with torch.inference_mode():
    # with torch.no_grad():
    generator = torch.Generator(device="cuda").manual_seed(1)
    a = time.perf_counter()
    image = pipe("a small cat", generator=generator)
    b = time.perf_counter()
    print(b - a, "first run")

    prompt = "a photo of an astronaut riding a horse on mars"
    # prompt = [prompt] * 128
    a = time.perf_counter()
    image = pipe(prompt)
    b = time.perf_counter()
    print(b - a, "second run")

    """
    times = []
    for i in range(10):
        a = time.perf_counter()
        image = pipe("dog")
        b = time.perf_counter()
        times.append(b - a)
    print(sum(times) / len(times), "average time for 10 runs")

    """
