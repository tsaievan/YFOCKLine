//
//  CCChartView.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import "CCChartView.h"
#import "UIColor+CCKLine.h"
#import <Masonry/Masonry.h>
#import "CCKLineView.h"
#import "CCKLineConstant.h"

@interface CCChartView () <CCChartSegmentViewDelegate>

/// K线图View
@property (nonatomic, strong) CCKLineView *kLineView;

/// 图标类型
@property (nonatomic, assign) CCKLineType currentCenterViewType;

/// 当前索引
@property (nonatomic, assign, readwrite) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableDictionary *cacheKLineData;
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
    
    self.kLineView = [[CCKLineView alloc] init];
    [self addSubview:self.kLineView];
    [self.kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.top.mas_equalTo(self);
        make.left.mas_equalTo(self.segmentView.mas_right);
    }];
}

- (void)reloadWithData:(CCKLineRootModel *)rootModel {
    /// 把模型加入缓存中
    self.cacheKLineData[@(self.currentIndex)] = rootModel;
    CCChartViewItemModel *itemModel = self.itemModels[self.currentIndex];
    
}

#pragma mark - CCChartSegmentViewDelegate
- (void)chartSegmentView:(CCChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index {
    self.currentIndex = index;
    if (index >= 100) {
        
    }
    else {
        
    }
}

@end

@implementation CCChartViewItemModel



@end
