//
//  ViewController.h
//  WaterFlowDisplay
//
//  Created by B.H. Liu on 12-3-29.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterflowView.h"

@interface ViewController : UIViewController<WaterflowViewDelegate,WaterflowViewDatasource,UIScrollViewDelegate>
{
    int count;
    WaterflowView *flowView;
}
@property (retain,nonatomic) NSMutableArray* queryArray;
@property (retain,nonatomic) NSMutableArray* feedsArray;

- (CGFloat)flowView:(WaterflowView *)flowView heightForCellAtIndex:(NSInteger)index;


@end
