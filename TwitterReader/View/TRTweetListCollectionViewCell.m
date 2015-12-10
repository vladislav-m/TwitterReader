//
//  TRTweetListCollectionViewCell.m
//  TwitterReader
//
//  Created by Vladislav Myakotin on 26.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import "TRTweetListCollectionViewCell.h"
#import "TRTweet.h"
#import "NSDateFormatter+Tools.h"

@interface TRTweetListCollectionViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetImageViewHeightConstraint;

@end

@implementation TRTweetListCollectionViewCell

-(void)setIsTweetImageVisible:(BOOL)isTweetImageVisible
{
    self.tweetImageViewHeightConstraint.constant = (isTweetImageVisible) ? self.tweetImageDefaultHeight : 0;
    [self layoutIfNeeded];
}

-(BOOL)isTweetImageVisible
{
    return (self.tweetImageViewHeightConstraint.constant != 0);
}

-(CGFloat)tweetImageDefaultHeight
{
    return 100.0;
}

-(CGFloat)cellHeightForTweet:(TRTweet*)tweet withWidth:(CGFloat)cellWidth
{
    //1. calculating date label width
    NSString * dateString = [[NSDateFormatter cachedDateFormatter] stringFromDate:tweet.createdAt];
    CGFloat dateLabelWidth = [dateString boundingRectWithSize:CGSizeMake(200.0, 40.0)
                                                      options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingUsesFontLeading
                                                   attributes:@{NSFontAttributeName : self.dateLabel.font}
                                                      context:nil].size.width;
    
    //2. calculating author label width and height
    CGFloat authorNameMaxWidth = cellWidth - self.authorNameLabel.frame.origin.x
    - dateLabelWidth - self.dateLabelTrailingConstraint.constant
    - self.authorLabelTrailingConstraint.constant;
    CGSize authorLabelSize = [tweet.author.name boundingRectWithSize:CGSizeMake(authorNameMaxWidth, 2000.0)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName : self.authorNameLabel.font}
                                                             context:nil].size;
    //3. calculating tweet text label height
    CGFloat textMaximumWidth = cellWidth - self.tweetTextLabel.frame.origin.x - self.textLabelTrailingConstraint.constant;
    CGFloat textHeight = [tweet.textWithoutPhotoURL boundingRectWithSize:CGSizeMake(textMaximumWidth, 2000.0)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName : self.tweetTextLabel.font} context:nil].size.height;
    //4. calculating image height
    
    CGFloat imageHeight = 0.0;
    if(tweet.photoURL != nil)
    {
        imageHeight = self.tweetImageDefaultHeight;
    }
    
    //5. calculating total cell height
    CGFloat calculatedCellHeight = self.authorNameLabel.frame.origin.y + ceil(authorLabelSize.height)
                                    + self.textLabelTopConstraint.constant + ceil(textHeight)
                                    + self.textLabelBottomConstraint.constant + imageHeight
                                    + self.tweetImageViewBottomConstraint.constant;
    
    CGFloat minimumCellHeight = self.authorAvatarImageView.frame.origin.y * 2.0 + self.authorAvatarImageView.frame.size.height;
    
    return (calculatedCellHeight < minimumCellHeight) ? minimumCellHeight : calculatedCellHeight;
}

@end
