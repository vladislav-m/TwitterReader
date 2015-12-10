//
//  TWTRTweet+Tools.m
//  TwitterReader
//
//  Created by Vladislav Myakotin on 26.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import "TWTRTweet+Tools.h"

@implementation TWTRTweet (Tools)

-(TWTRTweet*)originalTweet
{
    return (self.isRetweet) ? self.retweetedTweet : self;
}

@end
