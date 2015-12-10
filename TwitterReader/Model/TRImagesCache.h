//
//  TRImagesCache.h
//  TwitterReader
//
//  Created by Vladislav Myakotin on 27.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRImagesCache : NSObject

+(_Nonnull instancetype)sharedInstance;

-(void)getImageForURL:(NSString * _Nullable)imageURL
       withCompletion:(void(^ _Nonnull)(UIImage * _Nullable image, NSError * _Nullable error))completion;

-(void)cancelDownloadingImageForURL:(NSString * _Nonnull)imageURL;

@end
