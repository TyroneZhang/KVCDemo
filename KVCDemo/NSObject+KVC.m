//
//  NSObject+KVC.m
//  KVCDemo
//
//  Created by Demon_Yao on 2019/5/30.
//  Copyright © 2019 Tyrone Zhang. All rights reserved.
//

#import "NSObject+KVC.h"

@implementation NSObject (KVC)

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"Get value for Key(%@) from %@,but the key is not defined", key, self);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Set value for Key(%@) to %@, but the key is not defined", key, self);
}

- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"Set nil value for Key(%@) to %@", key, self);
}

@end
