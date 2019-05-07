//
//  Test7ViewController.m
//  Block-Demo
//
//  Created by 王泽龙 on 2019/5/7.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test7ViewController.h"
#import "Person.h"

@interface Test7ViewController ()

@end

@implementation Test7ViewController

- (void)viewDidLoad {
    
    self.title = @"block内存管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [self demo];
    [self demo1];
    [self demo2];
}

typedef void (^Block)(void);


/**
 __block修饰的变量在block结构体中一直都是强引用，而其他类型的是由传入的对象指针类型决定。
 一段代码更深入的观察一下。
 */
- (void)demo {
    
    int number = 20;
    __block int age = 10;
    
    NSObject *object = [[NSObject alloc] init];
    __weak NSObject *weakObj = object;
    
    Person *p = [[Person alloc] init];
    __block Person *person = p;
    __block __weak Person *weakPerson = p;
    
    Block block = ^ {
        NSLog(@"%d",number); // 局部变量
        NSLog(@"%d",age); // __block修饰的局部变量
        NSLog(@"%p",object); // 对象类型的局部变量
        NSLog(@"%p",weakObj); // __weak修饰的对象类型的局部变量
        NSLog(@"%p",person); // __block修饰的对象类型的局部变量
        NSLog(@"%p",weakPerson); // __block，__weak修饰的对象类型的局部变量
    };
    block();
    
    /*
     查看源码Test7ViewController.cpp：
     
     struct __Test7ViewController__demo_block_impl_0 {
     struct __block_impl impl;
     struct __Test7ViewController__demo_block_desc_0* Desc;
     int number;
     NSObject *__strong object;
     NSObject *__weak weakObj;
     __Block_byref_age_0 *age; // by ref
     __Block_byref_person_1 *person; // by ref
     __Block_byref_weakPerson_2 *weakPerson; // by ref
     __Test7ViewController__demo_block_impl_0(void *fp, struct __Test7ViewController__demo_block_desc_0 *desc, int _number, NSObject *__strong _object, NSObject *__weak _weakObj, __Block_byref_age_0 *_age, __Block_byref_person_1 *_person, __Block_byref_weakPerson_2 *_weakPerson, int flags=0) : number(_number), object(_object), weakObj(_weakObj), age(_age->__forwarding), person(_person->__forwarding), weakPerson(_weakPerson->__forwarding) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
     }
     };
     */
 
}


/**
 被__block修饰的对象类型的内存管理
 */
- (void)demo1 {
    
    __block Person *person = [[Person alloc] init];
    Block block = ^ {
        NSLog(@"%p", person);
    };
    block();
}

/**
 被__block修饰的对象类型的内存管理
 */
- (void)demo2 {
    
    Person *person = [[Person alloc] init];
    __block __weak Person *weakPerson = person;
    Block block = ^ {
        NSLog(@"%p", weakPerson);
    };
    block();
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
