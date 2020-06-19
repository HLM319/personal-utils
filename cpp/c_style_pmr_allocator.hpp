/* c_style_pmr_allocator
    A wrapper of C++17 pmr for C style definable malloc, free and realloc.

    Useage: Include this file before define malloc, free or realloc.
            Then do like this:
                #define MALLOC(size)         HLM319_c_style_pmr_allocator_malloc(size)
                #define FREE(p)              HLM319_c_style_pmr_allocator_free(p)
                #define REALLOC(p ,new_size) HLM319_c_style_pmr_allocator_realloc(p, new_size)

            My example when using stb_image:
                #include "c_style_pmr_allocator.hpp"
                #define STB_IMAGE_IMPLEMENTATION
                #define STBI_MALLOC(sz)       HLM319_c_style_pmr_allocator_malloc(sz)
                #define STBI_REALLOC(p,newsz) HLM319_c_style_pmr_allocator_realloc(p, newsz)
                #define STBI_FREE(p)          HLM319_c_style_pmr_allocator_free(p)
                #include "stb_image.h"
            This works well at my env.
*/

#ifndef _C_STYLE_PMR_ALLOCATOR_HPP_
#define _C_STYLE_PMR_ALLOCATOR_HPP_
#include <cstddef>
#include <cstring>
#include <memory_resource>

std::pmr::polymorphic_allocator<std::byte> HLM319_c_style_pmr_allocator;

void* HLM319_c_style_pmr_allocator_malloc(size_t size)
{
    size_t require_size = size + sizeof(size_t);
    auto raw_pointer = reinterpret_cast<size_t*>(HLM319_c_style_pmr_allocator.allocate(require_size));
    raw_pointer[0] = size;
    return reinterpret_cast<void*>(raw_pointer + 1);
}
void HLM319_c_style_pmr_allocator_free(void* p)
{
    auto raw_pointer = reinterpret_cast<size_t*>(p) - 1;
    HLM319_c_style_pmr_allocator.deallocate(reinterpret_cast<std::byte*>(raw_pointer), raw_pointer[0]);
}
void* HLM319_c_style_pmr_allocator_realloc(void* p, size_t new_size)
{
    auto new_pointer = malloc(new_size);
    std::memcpy(new_pointer, p, (reinterpret_cast<size_t*>(p) - 1)[0]);
    free(p);
    return new_pointer;
}
#endif //_C_STYLE_PMR_ALLOCATOR_HPP_
