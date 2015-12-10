//
//  TRTweet.h
//  TwitterReader
//
//  Created by Vladislav Myakotin on 27.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import <TwitterKit/TwitterKit.h>

@interface TRTweet : NSObject

+ (NSArray *)tweetsWithJSONArray:(NSArray *)array;

@property (strong, nonatomic) TWTRTweet * initialTweet;
@property (strong, nonatomic) NSString * photoURL;
@property (readonly, nonatomic) NSString * textWithoutPhotoURL;

@property (nonatomic, strong) NSString *tweetID;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) TWTRUser *author;
@property (nonatomic, assign) long long likeCount;
@property (nonatomic, assign) long long retweetCount;
@property (nonatomic, strong) NSString *inReplyToTweetID;
@property (nonatomic, strong) NSString *inReplyToUserID;
@property (nonatomic, strong) NSString *inReplyToScreenName;
@property (nonatomic, strong) NSURL *permalink;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) BOOL isRetweeted;
@property (nonatomic, strong) NSString *retweetID;
@property (nonatomic, assign) BOOL isRetweet;

@end
