//
//  SLClassInfo.h
//  04.class结构模拟
//
//  Created by fengsl on 2019/4/29.
//  Copyright © 2019 songlin. All rights reserved.
//

#ifndef SLClassInfo_h
#define SLClassInfo_h


# if __arm64__
#   define ISA_MASK        0x0000000ffffffff8ULL
# elif __x86_64__
#   define ISA_MASK        0x00007ffffffffff8ULL
# endif

#if __LP64__
typedef uint32_t mask_t;
#else
typedef uint16_t mask_t;
#endif
typedef uintptr_t cache_key_t;

struct bucket_t {
    cache_key_t _key;
    IMP _imp;
};

struct cache_t {
    bucket_t *_buckets;
    mask_t _mask;
    mask_t _occupied;
};

struct entsize_list_tt {
    uint32_t entsizeAndFlags;
    uint32_t count;
};

struct method_t {
    SEL name;
    const char *types;
    IMP imp;
};

struct method_list_t : entsize_list_tt {
    method_t first;
};

struct ivar_t {
    int32_t *offset;
    const char *name;
    const char *type;
    uint32_t alignment_raw;
    uint32_t size;
};

struct ivar_list_t : entsize_list_tt {
    ivar_t first;
};

struct property_t {
    const char *name;
    const char *attributes;
};

struct property_list_t : entsize_list_tt {
    property_t first;
};

struct chained_property_list {
    chained_property_list *next;
    uint32_t count;
    property_t list[0];
};

typedef uintptr_t protocol_ref_t;
struct protocol_list_t {
    uintptr_t count;
    protocol_ref_t list[0];
};

struct class_ro_t {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;  // instance对象占用的内存空间
#ifdef __LP64__
    uint32_t reserved;
#endif
    const uint8_t * ivarLayout;
    const char * name;  // 类名
    method_list_t * baseMethodList;
    protocol_list_t * baseProtocols;
    const ivar_list_t * ivars;  // 成员变量列表
    const uint8_t * weakIvarLayout;
    property_list_t *baseProperties;
};

struct class_rw_t {
    uint32_t flags;
    uint32_t version;
    const class_ro_t *ro;
    method_list_t * methods;    // 方法列表
    property_list_t *properties;    // 属性列表
    const protocol_list_t * protocols;  // 协议列表
    Class firstSubclass;
    Class nextSiblingClass;
    char *demangledName;
};

#define FAST_DATA_MASK          0x00007ffffffffff8UL
struct class_data_bits_t {
    uintptr_t bits;
public:
    class_rw_t* data() {
        return (class_rw_t *)(bits & FAST_DATA_MASK);
    }
};
union isa_t {
    isa_t() { }
    isa_t(uintptr_t value) : bits(value) { }
    
    Class cls;
    // 相当于是unsigned long bits;
    uintptr_t bits;
#if defined(ISA_BITFIELD)
    // 这里的定义在isa.h中，如下(注意uintptr_t实际上就是unsigned long)
    //    uintptr_t nonpointer        : 1;                                         \
    //    uintptr_t has_assoc         : 1;                                         \
    //    uintptr_t has_cxx_dtor      : 1;                                         \
    //    uintptr_t shiftcls          : 44; /*MACH_VM_MAX_ADDRESS 0x7fffffe00000*/ \
    //    uintptr_t magic             : 6;                                         \
    //    uintptr_t weakly_referenced : 1;                                         \
    //    uintptr_t deallocating      : 1;                                         \
    //    uintptr_t has_sidetable_rc  : 1;                                         \
    //    uintptr_t extra_rc          : 8
    
    struct {
        ISA_BITFIELD;  // defined in isa.h
    };
#endif
};

/* OC对象 */
struct fsl_objc_object {
      isa_t isa;
};

/* 类对象 */
struct fsl_objc_class : fsl_objc_object {
    Class superclass;
    cache_t cache;
    class_data_bits_t bits;
public:
    class_rw_t* data() {
        return bits.data();
    }
    
    fsl_objc_class* metaClass() {
        return (fsl_objc_class *)((long long)isa.bits & ISA_MASK);
    }
};

#endif /* SLClassInfo_h */
