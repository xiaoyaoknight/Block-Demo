//
//  Person.h
//  Block-Demo
//
//  Created by 王泽龙 on 2019/5/6.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^Block)(void);

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) int age;

@property (nonatomic, copy) Block block;

- (instancetype)initWithName:(NSString *)name;

+ (void) test2;

- (void)test;
@end

NS_ASSUME_NONNULL_END
