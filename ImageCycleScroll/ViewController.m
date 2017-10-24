//
//  ViewController.m
//  ImageCycleScroll
//
//  Created by Ansel on 2017/10/24.
//  Copyright © 2017年 Ansel. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollView.h"

@interface ViewController () <CycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [images addObject:[UIImage imageNamed:@"0"]];
    [images addObject:[UIImage imageNamed:@"1"]];
    [images addObject:[UIImage imageNamed:@"2"]];
    [images addObject:[UIImage imageNamed:@"3"]];
    [images addObject:[UIImage imageNamed:@"4"]];
    
    CycleScrollView *cycle = [[CycleScrollView alloc] initWithFrame:self.view.bounds
                                                     cycleDirection:CycleDirectionLandscape
                                                             images:images];
    cycle.delegate = self;
    [self.view addSubview:cycle];
}

#pragma mark - CycleScrollViewDelegate

- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(NSInteger)index {
    
}

- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(NSInteger)index {
    
    self.title = [NSString stringWithFormat:@"第%d张", (int)index];
}

@end
