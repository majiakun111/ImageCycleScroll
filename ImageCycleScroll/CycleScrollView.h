//
//  CycleScrollView.h
//  ImageCycleScroll
//
//  Created by Ansel on 2017/10/24.
//  Copyright © 2017年 Ansel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CycleDirection) {
    CycleDirectionPortait = 0,         // 垂直滚动
    CycleDirectionLandscape = 1        // 水平滚动
};

@class CycleScrollView;

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(NSInteger)index;
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(NSInteger)index;

@end

@interface CycleScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<CycleScrollViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction images:(NSArray *)images;

@end
