//
//  TZPerson.m
//  KVCDemo
//
//  Created by Demon_Yao on 2019/5/30.
//  Copyright © 2019 Tyrone Zhang. All rights reserved.
//

#import "TZPerson.h"

@implementation TZPerson

- (NSUInteger)countOfPersons {
    return self.count;
}

- (id)objectInPersonsAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"person %lu", index];
}

@end
