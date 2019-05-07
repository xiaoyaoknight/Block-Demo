//
//  Test3ViewController.m
//  KVO-Demo
//
//  Created by 王泽龙 on 2019/4/28.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test3ViewController.h"

@interface Test3ViewController ()

@end

@implementation Test3ViewController

- (void)viewDidLoad {
    
    self.title = @"block的类型";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
    [self demo1];
    NSLog(@"--------------------------");
    [self demo2];
    NSLog(@"--------------------------");
    [self demo3];
    NSLog(@"--------------------------");
    [self demo4];
    NSLog(@"--------------------------");
    [self demo5];
    
}

- (void)demo1 {
    
    // __NSGlobalBlock__ : __NSGlobalBlock : NSBlock : NSObject
    void (^block)(void) = ^{
        NSLog(@"Hello");
    };
    
    NSLog(@"%@", [block class]);
    NSLog(@"%@", [[block class] superclass]);
    NSLog(@"%@", [[[block class] superclass] superclass]);
    NSLog(@"%@", [[[[block class] superclass] superclass] superclass]);
}

- (void)demo2 {
    
    // 1. 内部没有调用外部变量的block
    void (^block1)(void) = ^{
        NSLog(@"Hello");
    };
    
    // 2. 内部调用外部变量的block
    int a = 10;
    void (^block2)(void) = ^{
        NSLog(@"Hello - %d",a);
    };
    
    // 3. 直接调用的block的class
    NSLog(@"%@ %@ %@", [block1 class], [block2 class], [^{
        NSLog(@"%d",a);
    } class]);

}

#pragma mark -------------- MRC --------------
- (void)demo3 {
    
    // Global：没有访问auto变量：__NSGlobalBlock__
    void (^block1)(void) = ^{
        NSLog(@"block1---------");
    };
    // Stack：访问了auto变量： __NSStackBlock__
    int a = 10;
    void (^block2)(void) = ^{
        NSLog(@"block2---------%d", a);
    };
    NSLog(@"%@ %@", [block1 class], [block2 class]);
    // __NSStackBlock__调用copy ： __NSMallocBlock__
    NSLog(@"%@", [[block2 copy] class]);

}


void (^block)(void);
void test() {
    // __NSStackBlock__
    int a = 10;
    block = ^{
        NSLog(@"block---------%d", a);
    };
}

/**
 __NSStackBlock__访问了auto变量，并且是存放在栈中的，上面提到过，栈中的代码在作用域结束之后内存就会被销毁，那么我们很有可能block内存销毁之后才去调用他，那样就会发生问题，通过下面代码可以证实这个问题。
 */
- (void)demo4 {
    test();
    block();
    
    //  block----------348944360
}

//void test1()
//{
//    // __NSStackBlock__ 调用copy 转化为__NSMallocBlock__
//    int age = 10;
//    block = [^{
//        NSLog(@"block---------%d", age);
//    } copy];
//    [block release];
//}

- (void)demo5 {
//    test1();
//    block();

    // 正常打印
    // block---------10
}

#pragma mark -------------- ARC --------------
typedef void (^Block)(void);
Block myblock() {
    int a = 10;
    // 上文提到过，block中访问了auto变量，此时block类型应为__NSStackBlock__
    Block block = ^{
        NSLog(@"---------%d", a);
    };
    return block;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
