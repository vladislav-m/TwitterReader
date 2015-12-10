//
//  TRTweet.m
//  TwitterReader
//
//  Created by Vladislav Myakotin on 27.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import "TRTweet.h"
#import "TWTRTweet+Tools.h"

@interface TRTweet()

@property (strong,nonatomic) NSString * urlToCutOff;

@end

@implementation TRTweet

+ (NSArray *)tweetsWithJSONArray:(NSArray *)array
{
    NSMutableArray * resultTweets = [NSMutableArray new];
    NSArray * tweets = [TWTRTweet tweetsWithJSONArray:array];
    
    for (int i = 0; i < array.count; i++)
    {
        TRTweet * resultTweet = [TRTweet new];
        [resultTweets addObject:resultTweet];
        NSDictionary * tweetDictionary = array[i];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"tweetID == %@", [tweetDictionary[@"id"] stringValue]];
        TWTRTweet * tweet = [[[tweets filteredArrayUsingPredicate:predicate] firstObject] originalTweet];
        
        resultTweet.initialTweet = tweet;
        
        resultTweet.tweetID = tweet.tweetID;
        resultTweet.createdAt = tweet.createdAt;
        resultTweet.text = tweet.text;
        resultTweet.author = tweet.author;
        resultTweet.likeCount = tweet.likeCount;
        resultTweet.retweetCount = tweet.retweetCount;
        resultTweet.inReplyToTweetID = tweet.inReplyToTweetID;
        resultTweet.inReplyToUserID = tweet.inReplyToUserID;
        resultTweet.inReplyToScreenName = tweet.inReplyToScreenName;
        resultTweet.permalink = tweet.permalink;
        resultTweet.isLiked = tweet.isLiked;
        resultTweet.isRetweeted = tweet.isRetweeted;
        resultTweet.retweetID = tweet.retweetID;
        resultTweet.isRetweet = tweet.isRetweet;
        
    
        NSDictionary * mediaDictionary = [tweetDictionary[@"entities"][@"media"] firstObject];
        if([mediaDictionary[@"type"] isEqualToString:@"photo"])
        {
            resultTweet.urlToCutOff = mediaDictionary[@"url"];
            resultTweet.photoURL = mediaDictionary[@"media_url_https"];
        }
    }
    return resultTweets;
}

-(NSString*)textWithoutPhotoURL
{
    if(self.urlToCutOff.length > 0)
    {
        return [self.text stringByReplacingOccurrencesOfString:self.urlToCutOff withString:@""];
    }
    else
    {
        return self.text;
    }
}

@end
