//
//  NSArray+Extension.m
//  ICUnicodeDemo
//
//  Created by andy  on 15/8/8.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import "NSArray+Extension.h"
#import "NSDictionary+Extension.h"

@implementation NSArray (Extension)

- (NSString *)formatArray:(NSArray *)array formatString:(NSString *)formatString {
    NSMutableString *string = [NSMutableString string];
    if (formatString == nil||formatString.length == 0) {
        formatString = @"\t";
        [string appendString:@"[\n"];
    }else {
        [string appendString:@"\t[\n"];
    }
    for (int i = 0; i<array.count; i++) {
        id value = array[i];
        NSString *arrayFormatString = [NSString stringWithFormat:@"%@%@",formatString,formatString];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [string appendFormat:@"%@%@\n",formatString,[value formatDictionary:value formatString:arrayFormatString]];
        }else if ([value isKindOfClass:[NSArray class]]) {
            [string appendFormat:@"%@%@\n",formatString,[self formatArray:value formatString:arrayFormatString]];
        }else{
            [string appendFormat:@"%@%@,\n",formatString,value];
        }
    }
    [string appendFormat:@"%@]",[formatString substringFromIndex:1]];
    return string;
}
- (NSString *)description {
    return [self formatArray:self formatString:nil];
}


//kvc 获取所有key值
+ (NSArray *)getAllIvar:(id)object
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int count;
    Ivar *ivars = class_copyIvarList([object class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *keyChar = ivar_getName(ivar);
        NSString *keyStr = [NSString stringWithCString:keyChar encoding:NSUTF8StringEncoding];
        @try {
            id valueStr = [object valueForKey:keyStr];
            NSDictionary *dic = nil;
            if (valueStr) {
                dic = @{keyStr : valueStr};
            } else {
                dic = @{keyStr : @"值为nil"};
            }
            [array addObject:dic];
        }
        @catch (NSException *exception) {}
    }
    return [array copy];
}

//获得所有属性
+ (NSArray *)getAllProperty:(id)object
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([object class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        const char *nameChar = property_getName(property);
        NSString *nameStr = [NSString stringWithCString:nameChar encoding:NSUTF8StringEncoding];
        [array addObject:nameStr];
    }
    return [array copy];
}




@end
