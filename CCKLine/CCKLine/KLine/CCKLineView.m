//
//  CCKLineView.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/5.
//

#import "CCKLineView.h"
#import <Masonry/Masonry.h>
#import "CCKLineGlobalVariable.h"
#import "UIColor+CCKLine.h"
#import "CCMinMaxModel.h"
#import "CCTimePainter.h"
#import "CCVerticalTextPainter.h"
#import "CCVolPainter.h"
#import "CCMACDPainter.h"
#import "CCMAPainter.h"

@interface CCKLineView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *painterView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
/// 长按后显示的View
@property (nonatomic, strong) UIView *verticalView;

/// 旧的scrollView准确位移
@property (nonatomic, assign) CGFloat oldExactOffset;
@property (nonatomic, assign) CGFloat pinchCenterX;
@property (nonatomic, assign) NSInteger pinchIndex;

/// 需要绘制Index开始值
@property (nonatomic, assign) NSInteger needDrawStartIndex;

/// 旧的contentOffset值
@property (nonatomic, assign) CGFloat oldContentOffsetX;

/// 旧的缩放值, 捏合
@property (nonatomic, assign) CGFloat oldScale;
@property (nonatomic, weak) MASConstraint *painterViewXConstraint;

/// 第一个view的高所占比例
@property (nonatomic, assign) CGFloat mainViewRatio;

/// 第二个view(成交量)的高所占比例
@property (nonatomic, assign) CGFloat volumeViewRatio;
@end

@implementation CCKLineView

static void dispatch_main_async_safe(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.mainViewRatio = [CCKLineGlobalVariable kLineMainViewRatio];
        self.volumeViewRatio = [CCKLineGlobalVariable kLineVolumeViewRatio];
        self.indicator1Painter = CCMAPainter.class;
        self.indicator2Painter = CCMACDPainter.class;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = UIColor.backgroundColor;
    /// 主图
    [self initScrollView];
    [self initPainterView];
    [self initRightView];
    [self initVerticalView];
    [self initLabel];
    /// 缩放
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(event_pinchMethod:)];
    [_scrollView addGestureRecognizer:pinchGesture];
    /// 长按
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(event_longPressMethod:)];
    [_scrollView addGestureRecognizer:longPressGesture];
}

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-CCKLineLinePriceViewWidth);
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
}

- (void)initPainterView {
    self.painterView = [[UIView alloc] init];
    [self.scrollView addSubview:self.painterView];
    [self.painterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(self.scrollView);
        self.painterViewXConstraint = make.left.mas_equalTo(self.scrollView);
    }];
}

- (void)initRightView {
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = UIColor.assistBackgroundColor;
    [self addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.width.mas_equalTo(@(CCKLineLinePriceViewWidth));
    }];
}

- (void)initVerticalView {
    self.verticalView = [[UIView alloc] init];
    self.verticalView.clipsToBounds = YES;
    [self.scrollView addSubview:self.verticalView];
    self.verticalView.backgroundColor = [UIColor longPressLineColor];
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(15);
        make.width.mas_equalTo(@(CCKLineLongPressVerticalViewWidth));
        make.height.mas_equalTo(self.scrollView.mas_height);
        make.left.mas_equalTo(-10);
    }];
    self.verticalView.hidden = YES;
}

- (void)initLabel {
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = [UIFont systemFontOfSize:10];
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(5);
        make.height.mas_equalTo(10);
    }];
    self.topLabel = label1;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = [UIFont systemFontOfSize:10];
    [self addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_bottom).multipliedBy(self.mainViewRatio).offset(5);
        make.height.mas_equalTo(10);
    }];
    self.middleLabel = label2;
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.font = [UIFont systemFontOfSize:10];
    [self addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_bottom).multipliedBy(self.mainViewRatio + self.volumeViewRatio).offset(5);
        make.height.mas_equalTo(10);
    }];
    self.bottomLabel = label3;
}

#pragma mark - 重绘
- (void)reDraw {
    dispatch_main_async_safe(^{
        CGFloat kLineViewWidth = self.rootModel.models.count * [CCKLineGlobalVariable kLineWidth] + (self.rootModel.models.count + 1) * [CCKLineGlobalVariable kLineGap] + 10;
        [self updateScrollViewContentSize];
        CGFloat offset = kLineViewWidth - self.scrollView.frame.size.width;
        self.scrollView.contentOffset  = CGPointMake(MAX(offset, 0), 0);
        if (offset == self.oldContentOffsetX) {
            [self calculateNeedDrawModels];
        }
    });
}

- (void)calculateNeedDrawModels {
    CGFloat lineGap = [CCKLineGlobalVariable kLineGap];
    CGFloat lineWidth = [CCKLineGlobalVariable kLineWidth];
    /// 数组个数
    NSInteger needDrawKLineCount = ceil(CGRectGetWidth(self.scrollView.frame) / (lineGap + lineWidth)) + 1;
    CGFloat scrollViewOffsetX = self.scrollView.contentOffset.x < 0 ? 0 : self.scrollView.contentOffset.x;
    NSUInteger leftArrCount = floor(scrollViewOffsetX / (lineGap + lineWidth));
    self.needDrawStartIndex = leftArrCount;
    
    NSArray *arr;
    if (self.needDrawStartIndex < self.rootModel.models.count) {
        if (self.needDrawStartIndex + needDrawKLineCount < self.rootModel.models.count) {
            arr = [self.rootModel.models subarrayWithRange:NSMakeRange(self.needDrawStartIndex, needDrawKLineCount)];
        }else {
            arr = [self.rootModel.models subarrayWithRange:NSMakeRange(self.needDrawStartIndex, self.rootModel.models.count - self.needDrawStartIndex)];
        }
    }
    [self drawWithModels:arr];
}

- (void)drawWithModels:(NSArray <CCKLineModel *> *)models {
    if (models.count <= 0) {
        return;
    }
    CCMinMaxModel *minMax = [[CCMinMaxModel alloc] init];
    minMax.min = CGFLOAT_MAX;
    [minMax combine:[self.linePainter getMinMaxValue:models]];
    if (self.indicator1Painter) {
        [minMax combine:[self.indicator1Painter getMinMaxValue: models]];
    }
    /// 移除旧的layer
    self.painterView.layer.sublayers = nil;
    self.rightView.layer.sublayers = nil;
    
    CGFloat offsetX = models.firstObject.index * (CCKLineGlobalVariable.kLineWidth + CCKLineGlobalVariable.kLineGap) - self.scrollView.contentOffset.x;
    CGRect mainArea = CGRectMake(offsetX, 20, CGRectGetWidth(self.painterView.bounds), CGRectGetHeight(self.painterView.bounds) * self.mainViewRatio - 40);
    CGRect secondArea = CGRectMake(offsetX, CGRectGetMaxY(mainArea) + 20, CGRectGetWidth(mainArea), CGRectGetHeight(self.painterView.bounds) * self.volumeViewRatio);
    CGRect thirdArea = CGRectMake(offsetX, CGRectGetMaxY(secondArea) + 20, CGRectGetWidth(mainArea), CGRectGetHeight(self.painterView.bounds) * (1 - self.mainViewRatio - self.volumeViewRatio) - 20);
    
    /// 时间轴
    [CCTimePainter drawToLayer:self.painterView.layer area:CGRectMake(offsetX, CGRectGetMaxY(mainArea), CGRectGetWidth(mainArea) + 20, 20) models:models minMax:minMax];
    /// 右侧价格轴
    [CCVerticalTextPainter drawToLayer:self.rightView.layer area:CGRectMake(0, 20, CCKLineLinePriceViewWidth, CGRectGetHeight(mainArea)) minMax:minMax];
    /// 右侧成交量轴
    [CCVerticalTextPainter drawToLayer:self.rightView.layer area:CGRectMake(0, CGRectGetMaxY(mainArea) + 20, CCKLineLinePriceViewWidth, CGRectGetHeight(secondArea)) minMax:[CCVolPainter getMinMaxValue:models]];
    /// 右侧副图
    [CCVerticalTextPainter drawToLayer:self.rightView.layer area:CGRectMake(0, thirdArea.origin.y, CCKLineLinePriceViewWidth, CGRectGetHeight(thirdArea)) minMax:[CCMACDPainter getMinMaxValue:models]];
    
    /// 主图
    [self.linePainter drawToLayer:self.painterView.layer area:mainArea models:models minMax: minMax];
    /// 主图指标图
    if (self.indicator1Painter) {
        [self.indicator1Painter drawToLayer:self.painterView.layer area:mainArea models:models minMax: minMax];
    }
    /// 成交量图
    [CCVolPainter drawToLayer:self.painterView.layer area:secondArea models:models minMax:[self.indicator2Painter getMinMaxValue:models]];
    /// 副图指标
    [self.indicator2Painter drawToLayer:self.painterView.layer area:thirdArea models:models minMax:[self.indicator2Painter getMinMaxValue:models]];
    /// 文字
    [self updateLabelText:models.lastObject];
}

- (void)updateLabelText:(CCKLineModel *)m {
    if (self.indicator1Painter) {
        self.topLabel.attributedText = [self.indicator1Painter getText:m];
    }else {
        self.topLabel.attributedText = m.V_Price;
    }
    self.middleLabel.attributedText = m.V_Volume;
    self.bottomLabel.attributedText = [self.indicator2Painter getText:m];
}

- (void)updateScrollViewContentSize {
    CGFloat contentSizeW = self.rootModel.models.count * [CCKLineGlobalVariable kLineWidth] + (self.rootModel.models.count - 1) * [CCKLineGlobalVariable kLineGap];
    self.scrollView.contentSize = CGSizeMake(contentSizeW, self.scrollView.contentSize.height);
}

#pragma mark - UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView.contentOffset.x < 0) {
        self.painterViewXConstraint.offset = 0;
    }else {
        self.painterViewXConstraint.offset = scrollView.contentOffset.x;
    }
    self.oldContentOffsetX = self.scrollView.contentOffset.x;
    [self calculateNeedDrawModels];
}

@end
