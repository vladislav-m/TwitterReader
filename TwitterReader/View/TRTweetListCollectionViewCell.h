//
//  TRTweetListCollectionViewCell.h
//  TwitterReader
//
//  Created by Vladislav Myakotin on 26.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRTweet;

@interface TRTweetListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *authorAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorLabelTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *tweetImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetImageViewBottomConstraint;

@property (assign, nonatomic) BOOL isTweetImageVisible;
@property (readonly, nonatomic) CGFloat tweetImageDefaultHeight;

-(CGFloat)cellHeightForTweet:(TRTweet*)tweet withWidth:(CGFloat)cellWidth;

@end
