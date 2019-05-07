//
//  Test8ViewController.m
//  Block-Demo
//
//  Created by 王泽龙 on 2019/5/7.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test8ViewController.h"
#import "Person.h"

@interface Test8ViewController ()

@end

@implementation Test8ViewController

- (void)viewDidLoad {
    
    self.title = @"循环引用";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
//    [self demo];
//    [self demo1];
    [self demo2];
//    [self demo3];
}

typedef void (^Block)(void);

/**
 循环引用
 */
- (void)demo {
    @autoreleasepool {
        Person *person = [[Person alloc] init];
        person.age = 10;
        person.block = ^{
            NSLog(@"%d",person.age);
        };
    }
    NSLog(@"大括号结束啦");

}


/**
 打破循环引用 __weak
 */
- (void)demo1 {
    
    @autoreleasepool {
        Person *person = [[Person alloc] init];
        person.age = 10;
//        __weak Person *weakPerson = person;
        __weak typeof(person) weakPerson = person;
        
        person.block = ^{
            NSLog(@"%d",weakPerson.age);
        };
    }
    NSLog(@"大括号结束啦");
}

- (void)demo2 {
    
    @autoreleasepool {
        Person *person = [[Person alloc] init];
        person.age = 10;
        __unsafe_unretained typeof(person) weakPerson = person;
        
        person.block = ^{
            NSLog(@"%d",weakPerson.age);
        };
    }
    NSLog(@"大括号结束啦");
}

- (void)demo3 {
    
    @autoreleasepool {
        __block Person *person = [[Person alloc] init];
        person.age = 10;
        person.block = ^{
            NSLog(@"%d",person.age);
            person = nil; // 必须置为nil
        };
        // 必须调用block 才会执行清空操作
        person.block();
    }
    NSLog(@"大括号结束啦");
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
