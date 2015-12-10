//
//  TRTweetGridCollectionViewCell.m
//  TwitterReader
//
//  Created by Vladislav Myakotin on 27.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import "TRTweetGridCollectionViewCell.h"
#import "TRTweet.h"

@implementation TRTweetGridCollectionViewCell

-(CGFloat)cellHeightForTweet:(TRTweet*)tweet withWidth:(CGFloat)cellWidth
{
    //1. calculating author label width and height
    CGFloat authorNameMaxWidth = cellWidth - self.authorNameLabel.frame.origin.x
                                    - self.authorLabelTrailingConstraint.constant;
    CGSize authorLabelSize = [tweet.author.name boundingRectWithSize:CGSizeMake(authorNameMaxWidth, 2000.0)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName : self.authorNameLabel.font}
                                                             context:nil].size;
    //2. calculating tweet text label height
    CGFloat textMaximumWidth = cellWidth - self.tweetTextLabel.frame.origin.x - self.textLabelTrailingConstraint.constant;
    CGFloat textHeight = [tweet.textWithoutPhotoURL boundingRectWithSize:CGSizeMake(textMaximumWidth, 2000.0)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName : self.tweetTextLabel.font} context:nil].size.height;
    //3. calculating image height
    
    CGFloat imageHeight = 0.0;
    if(tweet.photoURL != nil)
    {
        imageHeight = self.tweetImageDefaultHeight;
    }
    
    //4. calculating total cell height
    CGFloat calculatedCellHeight = self.authorNameLabel.frame.origin.y + ceil(authorLabelSize.height)
                                    + self.textLabelTopConstraint.constant + ceil(textHeight)
                                    + self.textLabelBottomConstraint.constant + imageHeight
                                    + self.tweetImageViewBottomConstraint.constant;
    
    return calculatedCellHeight;
}

@end
