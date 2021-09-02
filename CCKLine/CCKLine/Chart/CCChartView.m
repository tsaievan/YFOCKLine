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
#import "CCMACDPainter.h"
#import "CCRSIPainter.h"
#import "CCKDJPainter.h"
#import "CCWRPainter.h"
#import "CCMAPainter.h"
#import "CCEMAPainter.h"
#import "CCBOLLPainter.h"
#import "CCTimeLinePainter.h"
#import "CCCandlePainter.h"

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
        self.cacheKLineData = @{}.mutableCopy;
        [self initUI];
        self.itemModels = itemModels;
        NSMutableArray *items = [NSMutableArray array];
        for (CCChartViewItemModel *item in self.itemModels) {
            [items addObject:item.title];
        }
        self.segmentView.items = items;
        CCChartViewItemModel *firstModel = self.itemModels.firstObject;
        self.currentCenterViewType = firstModel.centerViewType;
        if (self.dataSource) {
            self.segmentView.selectedIndex = 4;
        }
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
    self.kLineView.rootModel = rootModel;
    self.kLineView.linePainter = itemModel.centerViewType == CCKLineTypeTimeLine ? CCTimeLinePainter.class : CCCandlePainter.class;
    [self.kLineView reDraw];
}

#pragma mark - CCChartSegmentViewDelegate
- (void)chartSegmentView:(CCChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index {
    self.currentIndex = index;
    if (index >= 100) {
        switch (index) {
            case CCKLineIndicatorMACD:
                self.kLineView.indicator2Painter = CCMACDPainter.class;
                break;
            case CCKLineIndicatorRSI:
                self.kLineView.indicator2Painter = CCRSIPainter.class;
                break;
            case CCKLineIndicatorKDJ:
                self.kLineView.indicator2Painter = CCKDJPainter.class;
                break;
            case CCKLineIndicatorWR:
                self.kLineView.indicator2Painter = CCWRPainter.class;
                break;
            case CCKLineIndicatorMA:
                self.kLineView.indicator2Painter = CCMAPainter.class;
                break;
            case CCKLineIndicatorEMA:
                self.kLineView.indicator2Painter = CCEMAPainter.class;
                break;
            case CCKLineIndicatorBOLL:
                self.kLineView.indicator2Painter = CCBOLLPainter.class;
                break;
            default:
                self.kLineView.indicator1Painter = nil;
                break;
        }
        [self.kLineView reDraw];
        [self bringSubviewToFront:self.segmentView];
    }
    else {
        if (self.cacheKLineData[@(index)]) {
            [self reloadWithData:self.cacheKLineData[@(index)]];
        }else {
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)]) {
                [self.dataSource stockDatasWithIndex:index];
            }
        }
    }
}

@end

@implementation CCChartViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title type:(CCKLineType)type {
    CCChartViewItemModel *itemModel = [[CCChartViewItemModel alloc] init];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}

@end
