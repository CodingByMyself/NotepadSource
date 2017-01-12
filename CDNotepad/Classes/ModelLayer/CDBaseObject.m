//
//  CDBaseObject.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseObject.h"
#import <objc/runtime.h>

@implementation CDBaseObject


/**
 *  重写当用 %@ 格式来打印模型时避免直接打印内存地址而是打印具体属性值等内容
 *
 *  @return 自定义打印描述
 */
- (NSString *)description
{
    NSMutableDictionary *temp = [NSMutableDictionary new];
    NSArray *propertyArray = [self getPropertyNames:[self class]];
    for (NSString *propertyName in propertyArray) {
        NSObject *obj = [self valueForKey:propertyName];
        [temp setObject:[NSString stringWithFormat:@"%@",obj] forKey:propertyName];
    }
    NSString *description = [NSString stringWithFormat:@"< %@模型属性值以JSON格式打印 > : %@",[self class],[temp JSONString]];
    return description;
    
}

- (NSArray*)getPropertyNames:(Class)clss
{
    NSMutableArray* array = [NSMutableArray new];
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    
    objc_property_t *properties = class_copyPropertyList(clss, &count);
    // 遍历
    for (int i = 0; i < count; i++) {
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *propertyName = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [array addObject:propertyName];
    }
    free(properties);
    
    [array removeObject:@"obj_id"];  //  此唯一公共属性去除,否则造成循环引用导致程序崩溃
    return array;
}

@end
