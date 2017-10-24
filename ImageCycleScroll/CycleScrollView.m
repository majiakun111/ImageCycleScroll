//
//  CycleScrollView.m
//  ImageCycleScroll
//
//  Created by Ansel on 2017/10/24.
//  Copyright © 2017年 Ansel. All rights reserved.
//
#import "CycleScrollView.h"

static const NSInteger ImageViewTag = 100000;

@interface CycleScrollView ()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) CycleDirection scrollDirection;  //scrollView滚动的方向
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, strong) NSArray *images;  //存放所有需要滚动的图片 UIImage

@end

@implementation CycleScrollView

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction images:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if(self) {
        self.scrollDirection = direction;
        self.currentPage = 0;
        self.images = images;
        
        [self addSubview:self.scrollView];
        [self refreshScrollView];
    }
    
    return self;
}

#pragma mark - Private Property

- (UIScrollView *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
        NSInteger contentCount = [self.images count] < 3 ? [self.images count] : 3;
        // 在水平方向滚动
        if(self.scrollDirection == CycleDirectionLandscape) {
            _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * contentCount, self.scrollView.frame.size.height);
        }
        // 在垂直方向滚动
        if(self.scrollDirection == CycleDirectionPortait) {
            _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height * contentCount);
        }
        
        if ([self.images count] <= 1) {
            [_scrollView setScrollEnabled:NO];
        }
    }
    
    return _scrollView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.images count] <= 2) {
        if ([self.delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]) {
            [self.delegate cycleScrollViewDelegate:self didScrollImageView:self.currentPage];
        }
        return;
    }
    
    if (self.scrollDirection == CycleDirectionLandscape) {  // 水平滚动
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        // 往下翻一张
        if(contentOffsetX >= (2 * self.scrollView.bounds.size.width)) {
            self.currentPage = [self getCurrentPage:self.currentPage + 1];
            [self refreshScrollView];
        } else if (contentOffsetX <= 0) {
            self.currentPage = [self getCurrentPage:self.currentPage - 1];
            [self refreshScrollView];
        }
    } else if (self.scrollDirection == CycleDirectionPortait) {// 垂直滚动
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        // 往下翻一张
        if(contentOffsetY >= 2 * (self.scrollView.bounds.size.height)) {
            self.currentPage = [self getCurrentPage:self.currentPage + 1];
            [self refreshScrollView];
        } else if(contentOffsetY <= 0) {
            self.currentPage = [self getCurrentPage:self.currentPage - 1];
            [self refreshScrollView];
        }
    }

    if ([self.delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]) {
        [self.delegate cycleScrollViewDelegate:self didScrollImageView:self.currentPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.images count] <= 2) {
        return;
    }
    
    if (self.scrollDirection == CycleDirectionLandscape) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0) animated:YES];
    } else if (self.scrollDirection == CycleDirectionPortait) {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.bounds.size.height) animated:YES];
    }
}

#pragma mark - PrivateMethod

- (void)refreshScrollView
{
    if([self.images count] <= 2) {
        [self displayImages:self.images];
        return;
    }
    
    NSArray *currentDisplayImages = [self getDisplayImages];
    [self displayImages:currentDisplayImages];
    
    if(self.scrollDirection == CycleDirectionLandscape) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0)];
    } else if (self.scrollDirection == CycleDirectionPortait) {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.bounds.size.height)];
    }
}

- (void)displayImages:(NSArray *)images
{
    for (int index = 0; index < [images count]; index++) {
        UIImageView *imageView = [self.scrollView viewWithTag:ImageViewTag + index];
        if (!imageView) {
            imageView = [[UIImageView alloc] init];
            imageView.tag = ImageViewTag + index;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:tapGestureRecognizer];
            [self.scrollView addSubview:imageView];
        }
        
        if(self.scrollDirection == CycleDirectionLandscape) {    // 水平滚动
            imageView.frame = CGRectMake(self.scrollView.bounds.size.width * index, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        } else if(self.scrollDirection == CycleDirectionPortait) { // 垂直滚动
            imageView.frame = CGRectMake(0, self.scrollView.bounds.size.height * index, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        }
        imageView.image = [images objectAtIndex:index];
    }
}

- (NSArray *)getDisplayImages
{
    NSInteger prePage = [self getPrePage];
    NSInteger nextPag = [self getNextPage];
    
    NSMutableArray *currentDisplayImages = @[].mutableCopy;
    [currentDisplayImages addObject:[self.images objectAtIndex:prePage]];
    [currentDisplayImages addObject:[self.images objectAtIndex:self.currentPage]];
    [currentDisplayImages addObject:[self.images objectAtIndex:nextPag]];
    
    return currentDisplayImages;
}

- (NSInteger)getPrePage
{
    NSInteger prePage;
    if (self.currentPage <= 0) {
        prePage = [self.images count] - 1;
    } else {
        prePage = self.currentPage - 1;
    }
    
    return prePage;
}

- (NSInteger)getNextPage
{
    NSInteger nextPage;
    if (self.currentPage >= [self.images count] - 1) {
        nextPage = 0;
    } else {
        nextPage = self.currentPage + 1;
    }
    
    return nextPage;
}

- (NSInteger)getCurrentPage:(NSInteger)page
{
    NSInteger currentPage;
    if (page == -1) {
        currentPage = [self.images count] - 1;
    } else if (page == [self.images count]) {
        currentPage = 0;
    } else {
        currentPage = page;
    }
    
    return currentPage;
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        [self.delegate cycleScrollViewDelegate:self didSelectImageView:self.currentPage];
    }
}

@end
