//
//  Test3ViewController.m
//  KVO-Demo
//
//  Created by 王泽龙 on 2019/4/28.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test4ViewController.h"
#import "Person.h"

@interface Test4ViewController ()

@end

@implementation Test4ViewController


- (void)viewDidLoad {
    
    self.title = @"block对对象变量的捕获";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
   
//    [self demo1];
//
//    [self demo2];
//
//    [self demo3];
//
//    [self demo4];

    [self demo5];
    
//    [self demo6];
}

typedef void (^Block)(void);

/**
 大括号执行完毕之后，person依然不会被释放。
 person为auto变量，传入的block的变量同样为person，
 即block有一个强引用引用person，所以block不被销毁的话，peroson也不会销毁。
 */
- (void)demo1 {
    Block block;
    {
        Person *person = [[Person alloc] init];
        person.age = 10;
        
        block = ^{
            NSLog(@"------block内部%d",person.age);
        };
    } // 执行完毕，person没有被释放
    NSLog(@"--------");
}

- (void)demo2 {
    Block block;
    {
        Person *person = [[Person alloc] init];
        person.age = 10;
        
        __weak Person *waekPerson = person;
        block = ^{
            NSLog(@"------block内部%d",waekPerson.age);
        };
    }
    // __weak添加之后，`person`在作用域执行完毕之后就被销毁了。
    NSLog(@"--------");
}

/**
 下列代码person在何时销毁 ？
 答：上文提到过ARC环境中，block作为GCD API的方法参数时会自动进行copy操作，因此block在堆空间，并且使用强引用访问person对象，因此block内部copy函数会对person进行强引用。当block执行完毕需要被销毁时，调用dispose函数释放对person对象的引用,person没有强指针指向时才会被销毁。
 */
- (void)demo3 {
    Person *person = [[Person alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@",person);
    });
    NSLog(@"touchBegin----------End");// 当block执行完毕persion销毁

}

- (void)demo4 {
    Person *person = [[Person alloc] init];
    __weak Person *weakP = person;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@",weakP);
    });
    
    NSLog(@"touchBegin----------End");
    
    /*
     block中对weakP为__weak弱引用，因此block内部copy函数会对person同样进行弱引用，当大括号执行完毕时，
     person对象没有强指针引用就会被释放。因此block块执行的时候打印null。
     
     2019-05-07 10:57:16.941473+0800 Block-Demo[21186:5509180] touchBegin----------End
     2019-05-07 10:57:18.104955+0800 Block-Demo[21186:5509180] -[Person dealloc]
     2019-05-07 10:57:21.423066+0800 Block-Demo[21186:5509180] (null)
     */
}

/**
 person对象4秒后销毁
 */
- (void)demo5 {
    
    Person *person = [[Person alloc] init];
    __weak Person *weakP = person;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"weakP ----- %@",weakP);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"person ----- %@",person);
        });
    });
    NSLog(@"touchBegin----------End");
    
    /*
     2019-05-07 11:12:25.682019+0800 Block-Demo[21576:5519004] touchBegin----------End
     2019-05-07 11:12:26.682303+0800 Block-Demo[21576:5519004] weakP ----- <Person: 0x600000cc1660>
     2019-05-07 11:12:29.682763+0800 Block-Demo[21576:5519004] person ----- <Person: 0x600000cc1660>
     2019-05-07 11:12:29.682978+0800 Block-Demo[21576:5519004] -[Person dealloc]
     */

}


/**
 person对象1秒后销毁
 */
- (void)demo6 {
    
    Person *person = [[Person alloc] init];
    __weak Person *waekP = person;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"person ----- %@",person);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"weakP ----- %@",waekP);
        });
    });
    NSLog(@"touchBegin----------End");
    
    /*
     2019-05-07 11:09:56.344279+0800 Block-Demo[21531:5517766] touchBegin----------End
     2019-05-07 11:09:57.344452+0800 Block-Demo[21531:5517766] person ----- <Person: 0x600002594b80>
     2019-05-07 11:09:57.344624+0800 Block-Demo[21531:5517766] -[Person dealloc]
     2019-05-07 11:10:00.344694+0800 Block-Demo[21531:5517766] weakP ----- (null)
     */
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
