//
//  ViewController.m
//  KVCDemo
//
//  Created by Demon_Yao on 2019/5/30.
//  Copyright © 2019 Tyrone Zhang. All rights reserved.
//

#import "ViewController.h"
#import "TZCard.h"
#import "TZPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self kvcBasicUsage];
    
//    [self verifySetValueMechanism];
    
//    [self verifyGetValueMechanism];
    
//    [self testKVCException];
    
//    [self dictionaryWithKVC];
    
//    [self arrayWithKVC];
    
//    [self aggregationOperations];
    
//    [self nestingOperators];
    
    [self representingNonObjectValues];
}

- (void)kvcBasicUsage {
    TZCard *idcard = [[TZCard alloc] init];
    [idcard setValue:@"tyrone" forKey:@"name"];
    NSLog(@"name = %@", [idcard valueForKey:@"name"]);
}

- (void)verifySetValueMechanism {
    TZCard *idcard = [[TZCard alloc] init];
    
    [idcard setValue:@"tyrone" forKey:@"name"];
//    NSLog(@"name = %@", idcard->name);
//    NSLog(@"name = %@", idcard->_name);
    NSLog(@"name = %@", idcard->isName);
//    NSLog(@"name = %@", idcard->_isName);
}

- (void)verifyGetValueMechanism {
    TZCard *idcard = [[TZCard alloc] init];
    
    [idcard setValue:@"tyrone" forKey:@"name"];
    NSLog(@"name = %@", [idcard valueForKey:@"name"]); // 这个证明找的就是变量。
}

- (void)testKVCException {
    TZCard *idcard = [TZCard new];
    
    // key不存在
//    [idcard setValue:@"tyrone" forKey:@"name1"];
    
//    [idcard valueForKey:@"name1"];
    
    // 设置空值到非对象类型
    [idcard setValue:nil forKey:@"age"];
    
}

- (void)dictionaryWithKVC {
    TZPerson *person = [TZPerson new];
    
    NSDictionary *dict = @{
                           @"name": @"tyrone",
                           @"age": @18,
                           @"height": @168,
                           @"errorkey": @"errorKey"
                           };
    [person setValuesForKeysWithDictionary:dict];
    NSLog(@"name = %@, age = %ld, height = %f", person->name, (long)person->age, person->height);
    
    NSArray *keys = @[@"name", @"age"];
    NSDictionary *dict1 = [person dictionaryWithValuesForKeys:keys];
    NSLog(@"name = %@", dict1);
}

- (void)arrayWithKVC {
    NSArray *arr = @[@"Tyrone", @"Sherly", @"Jerry"];
    NSArray *lengthArr = [arr valueForKey:@"length"];
    NSLog(@"lengthArr = %@", lengthArr);

    NSArray *lowcaseArr = [arr valueForKey:@"lowercaseString"];
    NSLog(@"lowcaseArr = %@", lowcaseArr);
}

#pragma mark - kvc的集合操作符

/// 聚合操作符(@avg @min @max @sum @count)
- (void)aggregationOperations {
    NSMutableArray *students = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i < 10; i++) {
        TZPerson *person = [TZPerson new];
        NSDictionary *dict = @{
                               @"name": @"tyrone",
                               @"age": @(18 + i),
                               @"height": @(1.1 + arc4random() % 100 / 100.0)
                               };
        [person setValuesForKeysWithDictionary:dict];
        [students addObject:person];
    }
    
    float avgHeight = [[students valueForKeyPath:@"@avg.height"] floatValue];
    float maxHeight = [[students valueForKeyPath:@"@max.height"] floatValue];
    NSLog(@"avgHeight = %f, maxHeight = %f", avgHeight, maxHeight);
}

/// 数组操作符（@distinctUnionOfObjects， @unionOfObjects）
- (void)arrayOperators {
    NSMutableArray *students = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i < 10; i++) {
        TZPerson *person = [TZPerson new];
        NSDictionary *dict = @{
                               @"name": @"tyrone",
                               @"age": @(18 + i),
                               @"height": @(1.1 + arc4random() % 10 / 10.0)
                               };
        [person setValuesForKeysWithDictionary:dict];
        [students addObject:person];
    }
    
    NSArray *arr1 = [students valueForKeyPath:@"@distinctUnionOfObjects.height"];
    NSArray *arr2 = [students valueForKeyPath:@"@unionOfObjects.height"];
    NSLog(@"arr1 = %@", arr1);
    NSLog(@"arr2 = %@", arr2);
}

/// 嵌套操作符(@distinctUnionOfArrays @unionOfArrays @distinctUnionOfSets)
- (void)nestingOperators {
    NSMutableArray *students = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 10; i++) {
        TZPerson *person = [TZPerson new];
        NSDictionary *dict = @{
                               @"name": @"tyrone",
                               @"age": @(18 + i),
                               @"height": @(1.1 + arc4random() % 10 / 10.0)
                               };
        [person setValuesForKeysWithDictionary:dict];
        [students addObject:person];
    }
    
    NSMutableArray *students1 = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 10; i++) {
        TZPerson *person = [TZPerson new];
        NSDictionary *dict = @{
                               @"name": @"tyrone",
                               @"age": @(18 + i),
                               @"height": @(1.1 + arc4random() % 10 / 10.0)
                               };
        [person setValuesForKeysWithDictionary:dict];
        [students1 addObject:person];
    }
    
    
    NSArray *studentsArr = @[students, students1];
    NSArray *arr1 = [studentsArr valueForKeyPath:@"@distinctUnionOfArrays.height"];
    NSArray *arr2 = [studentsArr valueForKeyPath:@"@unionOfArrays.height"];
    NSLog(@"arr1 = %@", arr1);
    NSLog(@"arr2 = %@", arr2);
}

#pragma mark - 集合代理对象

- (void)representingNonObjectValues {
    TZPerson *p = [TZPerson new];
    p.count = 4;
    NSLog(@"counts = %@", [p valueForKey:@"persons"]);
}

@end
