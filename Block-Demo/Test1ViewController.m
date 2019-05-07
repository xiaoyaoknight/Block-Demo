//
//  Test1ViewController.m
//  KVO-Demo
//
//  Created by 王泽龙 on 2019/4/28.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test1ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
};
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};
// 模仿系统__main_block_impl_0结构体
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    int age;
};


/**
 探寻block的本质
 */
- (void)viewDidLoad {
    self.title = @"探寻block的本质";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    
    int age = 10;
    void(^block)(int ,int) = ^(int a, int b){
        NSLog(@"this is block,a = %d,b = %d",a,b);
        NSLog(@"this is block,age = %d",age);
    };
    
    // 将底层的结构体强制转化为我们自己写的结构体，通过我们自定义的结构体探寻block底层结构体
    struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)block;
    block(3,5);

}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
