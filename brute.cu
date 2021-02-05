#include <cuda.h>
#include <stdint.h>
#include "md5.cu"

int main() {
    char* h_str = "a";
    char* d_str;
    char* h_res = (char*)malloc(sizeof(char)*(32 + 1));
    char* d_res;
    cudaMalloc((void**)&d_str, sizeof(char));
    cudaMalloc((void**)&d_res, sizeof(char)* 32);
    cudaMemcpy(d_str, h_str, sizeof(char), cudaMemcpyHostToDevice);

    md5<<<1, 1>>>(d_str, (uint32_t)sizeof(h_str), d_res);

    cudaMemcpy(h_res, d_res, sizeof(char)*(32), cudaMemcpyDeviceToHost);

    cudaFree(d_str);
    cudaFree(d_res);

    for (int i = 0; i < 32; i++) {
        printf("%2.2x", h_res[i]);
    }
    puts("");
};