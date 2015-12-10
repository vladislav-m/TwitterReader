//
//  TRFlowViewController.m
//  TwitterReader
//
//  Created by Vladislav Myakotin on 25.11.15.
//  Copyright © 2015 Vladislav Myakotin. All rights reserved.
//

#import "TRFlowViewController.h"
#import "TRTweetsService.h"
#import "UIViewController+ErrorAlert.h"
#import "TRTweetListCollectionViewCell.h"
#import "TRTweet.h"
#import "TRImagesCache.h"
#import "NSDateFormatter+Tools.h"

typedef NS_ENUM(NSInteger, TRFlowViewControllerMode)
{
    TRFlowViewControllerModeList = 0,
    TRFlowViewControllerModeGrid = 1
};

@interface TRFlowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *notLoggedInView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *noTweetsView;
@property (strong, nonatomic) NSMutableArray * tweets;
@property (readonly, nonatomic) TRTweetListCollectionViewCell * templateCell;
@property (strong, nonatomic) TRTweetListCollectionViewCell * templateCellList;
@property (strong, nonatomic) TRTweetListCollectionViewCell * templateCellGrid;
@property (assign, nonatomic) TRFlowViewControllerMode mode;
@property (assign, nonatomic) BOOL loadingIsInProgress;

@end

@implementation TRFlowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tweets = [NSMutableArray new];

    [self.collectionView registerNib:[UINib nibWithNibName:@"TRTweetListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TRTweetListCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRTweetGridCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TRTweetGridCollectionViewCell"];
    
    self.templateCellList = [[NSBundle mainBundle] loadNibNamed:@"TRTweetListCollectionViewCell" owner:nil options:nil][0];
    self.templateCellGrid = [[NSBundle mainBundle] loadNibNamed:@"TRTweetGridCollectionViewCell" owner:nil options:nil][0];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateCollectionViewItemSize];
}

-(void)updateCollectionViewItemSize
{
    CGFloat itemOffset = 5.0;
    UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    if(self.mode == TRFlowViewControllerModeList)
    {
        flowLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width - itemOffset * 2.0, 100.0);
        flowLayout.minimumInteritemSpacing = 4.0;
        flowLayout.minimumLineSpacing = itemOffset;
    }
    else
    {
        flowLayout.itemSize = CGSizeMake((self.collectionView.frame.size.width - itemOffset * 3.0) / 2.0, 100.0);
        flowLayout.minimumInteritemSpacing = 4.0;
        flowLayout.minimumLineSpacing = itemOffset;
        flowLayout.sectionInset = UIEdgeInsetsMake(itemOffset, itemOffset, 0.0, itemOffset);
    }
    [flowLayout invalidateLayout];
}

-(void)setMode:(TRFlowViewControllerMode)mode
{
    _mode = mode;
    [self updateCollectionViewItemSize];
    [self.collectionView reloadData];
}

-(TRTweetListCollectionViewCell*)templateCell
{
    return (self.mode == TRFlowViewControllerModeList) ? self.templateCellList : self.templateCellGrid;
}

- (IBAction)modeSwitched:(UISegmentedControl*)sender
{
    self.mode = (sender.selectedSegmentIndex == 0) ? TRFlowViewControllerModeList : TRFlowViewControllerModeGrid;
}

-(IBAction)signIn
{
    self.progressView.hidden = NO;
    [self.activityIndicator startAnimating];
    
    __weak typeof(self)weakSelf = self;
    [[TRTweetsService sharedInstance] logInIfNeededWithCompletion:^(NSError * _Nullable error) {
        
        weakSelf.progressView.hidden = YES;
        [weakSelf.activityIndicator stopAnimating];
        
        if(error != nil)
        {
            weakSelf.notLoggedInView.hidden = NO;
            [weakSelf showErrorAlert:@"Unable to log in with Twitter"];
        }
        else
        {
            self.notLoggedInView.hidden = YES;
            [weakSelf reloadData];
        }
    }];
}

- (IBAction)reloadData
{
    [self.tweets removeAllObjects];
    [[TRTweetsService sharedInstance] clearCache];
    
    self.progressView.hidden = NO;
    [self.activityIndicator startAnimating];
    __weak typeof(self)weakSelf = self;
    [self loadNextTweetsSliceWithCompletion:^{
        weakSelf.progressView.hidden = YES;
        [weakSelf.activityIndicator stopAnimating];
    }];
}

-(void)loadNextTweetsSlice
{
    [self loadNextTweetsSliceWithCompletion:nil];
}

-(void)loadNextTweetsSliceWithCompletion:(void(^)(void))completion
{
    if(self.loadingIsInProgress)
    {
        return;
    }
    
    self.loadingIsInProgress = YES;
    __weak typeof(self)weakSelf = self;
    [[TRTweetsService sharedInstance] loadNextPageTweets:^(NSArray * _Nullable tweets, NSError * _Nullable error) {
        weakSelf.loadingIsInProgress = NO;
        if(tweets != nil)
        {
            [weakSelf.tweets addObjectsFromArray:tweets];
            [weakSelf.collectionView reloadData];
        }
        else if(error != nil)
        {
            [weakSelf showErrorAlert:@"Unable to load tweets"];
        }
        
        weakSelf.noTweetsView.hidden = weakSelf.tweets.count != 0;
        
        if(completion != nil)
        {
            completion();
        }
    }];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRTweet * tweet = self.tweets[indexPath.item];
    
    NSString * cellIdentifier = (self.mode == TRFlowViewControllerModeList)
                                ? @"TRTweetListCollectionViewCell"
                                : @"TRTweetGridCollectionViewCell";
    
    TRTweetListCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.tweetTextLabel.text = tweet.textWithoutPhotoURL;
    cell.authorNameLabel.text = tweet.author.name;
    cell.dateLabel.text = [[NSDateFormatter cachedDateFormatter] stringFromDate:tweet.createdAt];
    cell.authorAvatarImageView.image = nil;
    
    if(tweet.author.profileImageLargeURL != nil)
    {
        [[TRImagesCache sharedInstance] getImageForURL:tweet.author.profileImageLargeURL withCompletion:^(UIImage *image, NSError *error)
        {
            cell.authorAvatarImageView.image = image;
        }];
    }
    
    cell.isTweetImageVisible = tweet.photoURL != nil;
    cell.tweetImageView.image = nil;
    
    if(tweet.photoURL != nil)
    {
        [[TRImagesCache sharedInstance] getImageForURL:tweet.photoURL withCompletion:^(UIImage *image, NSError *error)
         {
             cell.tweetImageView.image = image;
         }];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRTweet * tweet = self.tweets[indexPath.item];
    CGFloat cellWidth = ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize.width;
    return CGSizeMake(cellWidth, [self.templateCell cellHeightForTweet:tweet withWidth:cellWidth]);
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 20;
    if(y > h + reload_distance) {
        switch (aScrollView.panGestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged:
                // User is currently dragging the scroll view
                [self loadNextTweetsSlice];
                break;
                
            default:
                break;
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tweets.count <= indexPath.item)
    {
        return;
    }
    TRTweet * tweet = self.tweets[indexPath.item];
    if(tweet.photoURL != nil)
    {
        [[TRImagesCache sharedInstance] cancelDownloadingImageForURL:tweet.photoURL];
    }
}

@end
