//
//  Person.m
//  Block-Demo
//
//  Created by 王泽龙 on 2019/5/6.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

+ (void) test2 {
    NSLog(@"类方法test2");
}

- (void)test {
    
    void(^block)(void) = ^{
        NSLog(@"%@",self);
    };
    block();
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
