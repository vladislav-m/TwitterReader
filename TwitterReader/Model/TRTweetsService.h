//
//  TRTweetsService.h
//  TwitterReader
//
//  Created by Vladislav Myakotin on 26.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRTweetsService : NSObject

@property(nonatomic,readonly) BOOL isLoggedIn;

+(_Nonnull instancetype)sharedInstance;

-(void)logInIfNeededWithCompletion:(void(^ _Nullable)(NSError * _Nullable error))completion;

-(void)loadNextPageTweets:(void(^ _Nonnull)(NSArray * _Nullable tweets, NSError * _Nullable error))completion;

-(void)clearCache;

@end