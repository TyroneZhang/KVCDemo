//
//  TZPerson.h
//  KVCDemo
//
//  Created by Demon_Yao on 2019/5/30.
//  Copyright © 2019 Tyrone Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TZPerson : NSObject
{
    @public
    NSString *name;
    NSInteger age;
    float height;
}

@property (nonatomic, assign) NSUInteger count;

@end

NS_ASSUME_NONNULL_END
