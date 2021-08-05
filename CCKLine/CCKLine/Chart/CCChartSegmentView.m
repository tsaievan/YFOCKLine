//
//  CCChartSegmentView.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import "CCChartSegmentView.h"
#import "UIColor+CCKLine.h"

static NSInteger const CCChartSegmentStartTag = 2000;
@interface CCChartSegmentView ()
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIButton *secondLevelSelectedButton1;
@property (nonatomic, strong) UIButton *secondLevelSelectedButton2;
@end

@implementation CCChartSegmentView

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super initWithFrame:CGRectZero]) {
        self.items = items;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = UIColor.assistBackgroundColor;
    }
    return self;
}


@end
