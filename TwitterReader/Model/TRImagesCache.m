//
//  TRImagesCache.m
//  TwitterReader
//
//  Created by Vladislav Myakotin on 27.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import "TRImagesCache.h"

@interface TRImagesCache()

@property (strong,nonatomic) NSMutableDictionary * downloadTasks;

@end

@implementation TRImagesCache

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
        self.downloadTasks = [NSMutableDictionary new];
    }
    return self;
}

-(void)getImageForURL:(NSString * _Nullable)imageURL
       withCompletion:(void(^ _Nonnull)(UIImage * _Nullable image, NSError * _Nullable error))completion
{
    if(imageURL.length > 0)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
        {
            NSString * fileName = [imageURL stringByReplacingOccurrencesOfString:@"/" withString:@""];
            NSArray * pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString * myPath = [[pathList firstObject] stringByAppendingPathComponent:fileName];
            if([[NSFileManager defaultManager] fileExistsAtPath:myPath])
            {
                UIImage * image = [UIImage imageWithContentsOfFile:myPath];
                dispatch_sync(dispatch_get_main_queue(), ^
                {
                    completion(image,nil);
                });
            }
            else
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
                
                //TODO: handle case when same image started to download second time during first download is still in progress
                
                NSURLSessionDataTask * sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                      
               {
                   if (error != nil)
                   {
                       dispatch_sync(dispatch_get_main_queue(), ^
                       {
                           completion(nil,error);
                       });
                   }
                   else
                   {
                       [data writeToFile:myPath atomically:YES];
                       UIImage * image = [UIImage imageWithData:data];
                       dispatch_async(dispatch_get_main_queue(), ^{
                           completion(image, error);
                       });
                   }

               }];
                self.downloadTasks[imageURL] = sessionTask;
                [sessionTask resume];
            }
        });
    }
    else
    {
        completion(nil,nil);
    }
}

-(void)cancelDownloadingImageForURL:(NSString * _Nonnull)imageURL
{
    [self.downloadTasks[imageURL] cancel];
    [self.downloadTasks removeObjectForKey:imageURL];
}

@end
