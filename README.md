#  KVC

## KVC基本用法
``` OBjective-C
@interface TZCard : NSObject
{
@protected
NSString *_name;
}

@end

TZCard *idcard = [[TZCard alloc] init];
[idcard setValue:@"tyrone" forKey:@"name"];
NSLog(@"name = %@", [idcard valueForKey:@"name"]); // thie will print tyrone

```
## KVC赋值取值过程分析

### 赋值过程
1. [obj valueForKey:]会按照set<Key>、_set<Key> 、setIs<Key>三个方法顺序进行查找赋值；
2.  如果1.中的三个方法都未实现，从`+ (BOOL)accessInstanceVariablesDirectly // 默认返回的是YES`方法中获取bool值，, 如果返回的是NO,会执行valueForUndefinedKey:方法，抛出异常，然后crash；
3. 如果返回的是YES， 根据顺序_<key>、_is<Key>、<key>、is<Key>寻找相关变量；
4. 若方法或成员变量都不存在，执行valueForUndefinedKey:方法，抛出异常，然后crash；

测试代码如下：
``` Objective-C

@interface TZCard : NSObject
{
@public
//    NSString *_name;
//    NSString *name;
NSString *isName;
//    NSString *_isName;
}

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


- (void)verifySetValueMechanism {
TZCard *idcard = [[TZCard alloc] init];

[idcard setValue:@"tyrone" forKey:@"name"];
//    NSLog(@"name = %@", idcard->name);
//    NSLog(@"name = %@", idcard->_name);
NSLog(@"name = %@", idcard->isName); // 虽然key是‘name’,但这里仍然会打印出值 tyrone
//    NSLog(@"name = %@", idcard->_isName); 
}
```

### KVC取值过程
1. 按顺序寻找找相关方法 get<Key>、<key>;
2. 若没有相关方法, `+ (BOOL)accessInstanceVariablesDirectly` 判断是否可以直接访问c成员变量；
3. 如果是NO，执行valueForUndefinedKey:方法，抛出异常，然后crash；
4. 如果是YES，按照顺序_<key>、_is<Key>、<key>、is<Key>寻找相关变量;
5. 方法以及成员变量都未找到，执行valueForUndefinedKey:方法，抛出异常，然后crash。

## 自定义KVC

通过KVC存取步骤，通过runtime去获取所有成员变量，按照对应顺序去给成员变量赋值或者取出成员变量的值。

## KVC异常处理及正确性验证

1. 捕获valueForUndefinedKey异常，使程序不崩溃；
2. 捕获对非对象设置空值的异常。

``` Objective-C
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

```

## KVC进阶

### KVC with Dictionary
``` Objective-C

@interface TZPerson : NSObject
{
@public
NSString *name;
NSInteger age;
float height;
}

@end

```

``` Objective-C
TZPerson *person = [TZPerson new];

NSDictionary *dict = @{
@"name": @"tyrone",
@"age": @18,
@"height": @168,
@"errorkey": @"errorKey"
};
[person setValuesForKeysWithDictionary:dict];
NSLog(@"name = %@, age = %ld, height = %f", person->name, (long)person->age, person->height); // print "name = tyrone, age = 18, height = 168.000000"

NSArray *keys = @[@"name", @"age"];
NSDictionary *dict1 = [person dictionaryWithValuesForKeys:keys];
NSLog(@"%@", dict1); // print "{ age = 18; name = tyrone;}"
}
```
### KVC with Array
array执行valueForKey，会让数组里每一个元素执行key对应的方法(KVC消息传递)。
``` @objctive-C
- (void)arrayWithKVC {
NSArray *arr = @[@"Tyrone", @"Sherly", @"Jerry"];
NSArray *lengthArr = [arr valueForKey:@"length"];
NSLog(@"lengthArr = %@", lengthArr);

NSArray *lowcaseArr = [arr valueForKey:@"lowercaseString"];
NSLog(@"lowcaseArr = %@", lowcaseArr); // lowcaseArr = (tyrone, sherly, jerry)
}
```
### KVC集合操作符
#### 聚合操作符(@avg @min @max @sum @count)
``` @Objective-C
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
```
#### 数组操作符（@distinctUnionOfObjects， @unionOfObjects）
#### /// 嵌套操作符(@distinctUnionOfArrays @unionOfArrays @distinctUnionOfSets)
数组嵌套数组也能进行kvc的操作

### KVC集合代理对象

