//
//  CCChartView.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import "CCChartView.h"
#import "UIColor+CCKLine.h"
#import <Masonry/Masonry.h>

@interface CCChartView () <CCChartSegmentViewDelegate>

@end

@implementation CCChartView

- (instancetype)initWithItemModels:(NSArray *)itemModels {
    if (self = [super init]) {
        self.backgroundColor = UIColor.backgroundColor;
    }
    return self;
}

- (void)initUI {
    self.segmentView = [[CCChartSegmentView alloc] init];
    self.segmentView.delegate = self;
    [self addSubview:_segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.top.mas_equalTo(self);
        make.width.mas_equalTo(50);
    }];
}

@end

@implementation CCChartViewItemModel



@end
