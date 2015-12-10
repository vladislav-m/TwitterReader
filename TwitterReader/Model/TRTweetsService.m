//
//  TRTweetsService.m
//  TwitterReader
//
//  Created by Vladislav Myakotin on 26.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import "TRTweetsService.h"
#import <TwitterKit/TwitterKit.h>
#import "TRTweet.h"

static int kTweetsPerPage = 50;

@interface TRTweetsService()

@property (nonatomic,strong) TWTRSession * currentSession;
@property (nonatomic,strong) NSMutableArray * tweetsCache;

@end

@implementation TRTweetsService

+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    if(self = [super init])
    {
        self.tweetsCache = [NSMutableArray new];
    }
    return self;
}

-(void)logInIfNeededWithCompletion:(void(^ _Nullable)(NSError * _Nullable error))completion
{
    [self.tweetsCache removeAllObjects];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        if(error == nil)
        {
            self.currentSession = session;
        }
        if(completion != nil)
        {
            completion(error);
        }
    }];
}

-(BOOL)isLoggedIn
{
    return [[[Twitter sharedInstance] sessionStore] session] != nil;
}

-(void)loadNextPageTweets:(void(^ _Nonnull)(NSArray * _Nullable tweets, NSError * _Nullable error))completion
{
    TWTRAPIClient * client = [[TWTRAPIClient alloc] initWithUserID:self.currentSession.userID];
    
    NSMutableDictionary * parameters = [NSMutableDictionary new];
    parameters[@"count"] = [@(kTweetsPerPage) stringValue];
    if(self.tweetsCache.count > 0)
    {
        parameters[@"max_id"] = [@([[self.tweetsCache valueForKeyPath:@"@min.self"] integerValue] - 1) stringValue];
//        parameters[@"since_id"] = [self.tweetsCache valueForKeyPath:@"@max.self"];
    }
    
    NSError * error = nil;
    NSURLRequest * request = [client URLRequestWithMethod:@"GET"
                                                      URL:@"https://api.twitter.com/1.1/statuses/home_timeline.json"
                                               parameters:parameters
                                                    error:&error];
    [client sendTwitterRequest:request completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
     {
         if(data != nil)
         {
             NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
             NSArray * tweets = [TRTweet tweetsWithJSONArray:responseArray];
             NSArray * tweetsForCache = [TWTRTweet tweetsWithJSONArray:responseArray];
             [self.tweetsCache addObjectsFromArray:[tweetsForCache valueForKey:@"tweetID"]];
             completion(tweets,connectionError);
         }
         else
         {
             completion(nil,connectionError);
         }
    }];
}

-(void)clearCache
{
    [self.tweetsCache removeAllObjects];
}

@end
