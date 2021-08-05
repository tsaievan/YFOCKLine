//
//  CCChartSegmentView.h
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import <UIKit/UIKit.h>
@class CCChartSegmentView;
@protocol CCChartSegmentViewDelegate <NSObject>
- (void)chartSegmentView:(CCChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index;
@end

@interface CCChartSegmentView : UIView
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id <CCChartSegmentViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectedIndex;
@end

