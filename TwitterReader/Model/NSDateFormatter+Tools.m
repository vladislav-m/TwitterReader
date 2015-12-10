//
//  NSDateFormatter+Tools.m
//  TwitterReader
//
//  Created by Vladislav Myakotin on 27.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import "NSDateFormatter+Tools.h"

@implementation NSDateFormatter (Tools)

+(NSDateFormatter*)cachedDateFormatter
{
    static dispatch_once_t onceToken;
    static NSDateFormatter * cachedFormatter;
    
    dispatch_once(&onceToken, ^{
        cachedFormatter = [[NSDateFormatter alloc] init];
        cachedFormatter.dateStyle = NSDateFormatterShortStyle;
        cachedFormatter.timeStyle = NSDateFormatterNoStyle;
    });
    
    return cachedFormatter;
}

@end
