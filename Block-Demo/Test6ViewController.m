//
//  Test6ViewController.m
//  Block-Demo
//
//  Created by 王泽龙 on 2019/5/7.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test6ViewController.h"
#import "Person.h"

@interface Test6ViewController ()

@end

@implementation Test6ViewController

- (void)viewDidLoad {
    
    self.title = @"block修饰对象类型";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [self demo];
    [self demo1];
}

typedef void (^Block)(void);
/**
 通过源码查看，将对象包装在一个新的结构体中。
 结构体内部会有一个person对象，
 不一样的地方是结构体内部添加了内存管理的两个函数__Block_byref_id_object_copy和__Block_byref_id_object_dispose
 */
- (void)demo {
  
    __block Person *person = [[Person alloc] init];
    NSLog(@"%@",person);
    Block block = ^{
        person = [[Person alloc] init];
        NSLog(@"%@",person);
    };
    block();

}


typedef void (^Block)(void);
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
    void (*copy)(void);
    void (*dispose)(void);
};

struct __Block_byref_age_0 {
    void *__isa;
    struct __Block_byref_age_0 *__forwarding;
    int __flags;
    int __size;
    int age;
};
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    struct __Block_byref_age_0 *age; // by ref
};

- (void)demo1 {

    
    __block int age = 10;
    Block block = ^{
        age = 20;
        NSLog(@"age is %d",age);
    };
    block();
    struct __main_block_impl_0 *blockImpl = (__bridge struct __main_block_impl_0 *)block;
    // 打印断点查看结构体内部结构发现：
//    通过查看blockImpl结构体其中的内容，找到age结构体，其中重点观察两个元素：
//
//    __forwarding其中存储的地址确实是age结构体变量自己的地址
//    age中存储这修改后的变量20。

    NSLog(@"%p",&age);

}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
