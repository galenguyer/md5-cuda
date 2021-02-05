#include <cuda.h>
#include <stdint.h>
#include <string.h>
#include "md5.cu"

int main() {
    char* h_str = "a";
    char* d_str;
    unsigned char* h_res = (unsigned char*)malloc(sizeof(unsigned char)*(32 + 1));
    unsigned char* d_res;
    cudaMalloc((void**)&d_str, sizeof(char));
    cudaMalloc((void**)&d_res, sizeof(char)* 32);
    cudaMemcpy(d_str, h_str, sizeof(char), cudaMemcpyHostToDevice);

    md5<<<1, 1>>>(d_str, (uint32_t)strlen(h_str), d_res);

    cudaMemcpy(h_res, d_res, sizeof(unsigned char)*(32), cudaMemcpyDeviceToHost);

    cudaFree(d_str);
    cudaFree(d_res);

    char* res = (char*)malloc(sizeof(char)*32);
    for (int i = 0; i < 16; i++) {
        sprintf(&res[i*2], "%2.2x", h_res[i]);
    }
    
    puts(res);
}