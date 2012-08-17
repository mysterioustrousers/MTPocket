//
//  MTJSONDictionary.h
//  MTJSONDictionary
//
//  Created by Adam Kirk on 8/16/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//


@interface NSObject (MTJSONDictionary)

- (id)objectWithJSONSafeObjects;
- (NSData *)JSONData;

@end




@interface NSDictionary (MTJSONDictionary)

- (id)valueForComplexKeyPath:(NSString *)keyPath;
- (NSString *)stringValueForComplexKeyPath:(NSString *)key;

@end
