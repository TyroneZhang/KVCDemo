//
//  TZCard.m
//  KVCDemo
//
//  Created by Demon_Yao on 2019/5/30.
//  Copyright © 2019 Tyrone Zhang. All rights reserved.
//

#import "TZCard.h"

@implementation TZCard

//// 再寻找此方法
//- (void)_setName:(NSString *)name {
//    NSLog(@"%s", __func__);
//}
//
//// 先寻找此方法
//- (void)setName:(NSString *)name {
//    NSLog(@"%s", __func__);
//}
//
//// 最后寻找此方法
//- (void)setIsName:(NSString *)name {
//    NSLog(@"%s", __func__);
//}

/// 默认返回的是YES, 如果返回的是NO,且未实现画赋值方法，会执行valueForUndefinedKey:方法，抛出异常，然后crash。
+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

@end
