//
//  Test2ViewController.m
//  KVO-Demo
//
//  Created by 王泽龙 on 2019/4/28.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test2ViewController.h"
#import "Person.h"

@interface Test2ViewController ()

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    
    self.title = @"block的变量捕获";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    [self demo1];
    NSLog(@"--------------------------");
    
    [self demo2];
    NSLog(@"--------------------------");
    
    [self demo3];
    NSLog(@"--------------------------");
}

/**
 局部变量: 因为跨函数访问所以需要捕获
 */
- (void)demo1 {
    auto int a = 10;
    static int b = 11;
    void(^block)(void) = ^{
        NSLog(@"hello, a = %d, b = %d", a,b);
    };
    a = 1;
    b = 2;
    block();

    // log : hello, a = 10, b = 2
    // block中a的值没有被改变而b的值随外部变化而变化。
    
}


int aaa = 10;
static int bbb = 11;

/**
 全局变量: block不需要捕获全局变量，因为全局变量无论在哪里都可以访问。
 */
- (void)demo2 {
    void(^block)(void) = ^{
        NSLog(@"hello, aaa = %d, bbb = %d", aaa, bbb);
    };
    aaa = 1;
    bbb = 2;
    block();

}

- (void)demo3 {
    Person *person = [[Person alloc] initWithName:@"Tom"];
    [person test];
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
