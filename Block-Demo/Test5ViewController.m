//
//  Test5ViewController.m
//  KVO-Demo
//
//  Created by 王泽龙 on 2019/4/28.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test5ViewController.h"


@interface Test5ViewController ()
@end

@implementation Test5ViewController

- (void)viewDidLoad {
    
    self.title = @"block内修改变量的值";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [self demo];
    [self demo1];
    [self demo2];
}


typedef void (^Block)(void);

/**
 默认情况下block不能修改外部的局部变量。通过之前对源码的分析可以知道。
 
 `age`是在`main`函数内部声明的，说明`age`的内存存在于`main`函数的栈空间内部，
 但是`block`内部的代码在`__main_block_func_0`函数内部。
 `__main_block_func_0`函数内部无法访问`age`变量的内存空间，两个函数的栈空间不一样，
 `__main_block_func_0`内部拿到的`age`是`block`结构体内部的`age`，
 因此无法在`__main_block_func_0`函数内部去修改`main`函数内部的变量。
 */
- (void)demo {

    int age = 10;
    Block block = ^ {
        // age = 20; // 无法修改
        NSLog(@"normal %d",age);
    };
    block();
}


/**
 方式一：age使用static修饰。永久存在内存中！
 */
- (void)demo1 {
    
    static int age = 10;
    Block block = ^ {
        NSLog(@"static %d",age);
    };
    age = 20;
    block();
}


/**
 方式二：__block
 __block用于解决block内部不能修改auto变量值的问题，__block不能修饰静态变量（static） 和全局变量
 
 __block为什么能修改变量?
 __block将变量包装成对象，然后在把age封装在结构体里面，block内部存储的变量为结构体指针，也就可以通过指针找到内存地址进而修改变量的值。
 */
- (void)demo2 {
    
    __block auto int age = 10;
    Block block = ^ {
        age = 20;
        NSLog(@"__block %d",age);
    };
    
    block();
    
    /*
     查看Test5ViewController.cpp 源码发现：
     __block将变量包装成对象
     
     struct __Block_byref_age_0 {
     void *__isa;
     __Block_byref_age_0 *__forwarding;
     int __flags;
     int __size;
     int age;
     };
     */
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
