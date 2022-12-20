# Cuda optimizations of bubble sort

## Kernel dimensions for the GTX 1660 TI
warp size: 32
cuda cores: 1536
SM count: 24 each can have up to 8 Thread Blocks simulateniously
1024 threads need to execute!


Each SM has 64KB of cache (2^16)
Each thread accesses (1024*sizeof(int)) = 4094 bytes (2^12) in it's existence 
2^16 / 2^12 = 16 threads

Since the sm can only have up to 8 thread blocks:
8 thread blocks * 2 threads each

So for the 1024 matrices we'll need 1024/2 = 512 thread blocks.

So for the first 24 SM we would want to distribute 8 * 24 thread blocks = 192
the power of 2 next to it would be 128.
So the best configuration should be 128*4 thread blocks each with 2 threads!  