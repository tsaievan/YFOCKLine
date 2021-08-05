//
//  CCChartSegmentView.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import "CCChartSegmentView.h"
#import "UIColor+CCKLine.h"
#import <Masonry/Masonry.h>

static NSInteger const CCChartSegmentStartTag = 2000;
@interface CCChartSegmentView ()
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIButton *secondLevelSelectedButton1;
@property (nonatomic, strong) UIButton *secondLevelSelectedButton2;
@end

@implementation CCChartSegmentView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = UIColor.assistBackgroundColor;
    }
    return self;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = UIColor.assistBackgroundColor;
        NSArray *titleArray = @[@"MA", @"EMA", @"BOLL", @"关闭", @"MACD", @"KDJ", @"RSI", @"WR"];
        __block UIButton *preButton;
        /// 遍历创建button
        
        [titleArray enumerateObjectsUsingBlock:^(NSString *_Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            /// 加100, 是跟self上面的button做区分
            UIButton *button = [self private_createButtonWithTitle:title tag:CCChartSegmentStartTag + 100 + idx];
            [_indicatorView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.indicatorView).multipliedBy(1.f/titleArray.count);
                make.width.mas_equalTo(self.indicatorView);
                make.left.mas_equalTo(self.indicatorView);
                if (preButton) {
                    make.top.mas_equalTo(preButton.mas_bottom).offset(0.5);
                }else {
                    make.top.mas_equalTo(self.indicatorView);
                }
            }];
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:52.f/255.f green:56.f/255.f blue:67.f/255.f alpha:1];
            [_indicatorView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(button);
                make.top.mas_equalTo(button.mas_bottom);
                make.height.mas_equalTo(0.5);
            }];
            preButton = button;
        }];
        UIButton *firstButton = _indicatorView.subviews[0];
        [firstButton setSelected:YES];
        _secondLevelSelectedButton1 = firstButton;
        UIButton *firstButton2 = _indicatorView.subviews[8];
        [firstButton2 setSelected:YES];
        _secondLevelSelectedButton2 = firstButton2;
        [self addSubview:_indicatorView];
        /// 设置indicatorView的初始frame在self的左侧, 暂时不显示出来
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(self);
            make.right.mas_equalTo(self.mas_left);
        }];
    }
    return _indicatorView;
}

- (void)setItems:(NSArray *)items {
    _items = items;
    if (items.count == 0 || !items) {
        return;
    }
    NSInteger index = 0;
    NSInteger count = items.count;
    UIButton *preButton = nil;
    for (NSString *title in items) {
        UIButton *button = [self private_createButtonWithTitle:title tag:CCChartSegmentStartTag + index];
        /// 分割线
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:52.f/255.f green:56.f/255.f blue:67.f/255.f alpha:1];
        [self addSubview:button];
        [self addSubview:view];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.height.mas_equalTo(self).multipliedBy(1.f/count);
            make.width.equalTo(self);
            if (preButton) {
                make.top.mas_equalTo(preButton.mas_bottom).offset(0.5);
            }else {
                make.top.mas_equalTo(self);
            }
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(button);
            make.top.mas_equalTo(button.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        preButton = button;
        index++;
    }
}

#pragma mark - 设置底部按钮index
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    UIButton *button = (UIButton *)[self viewWithTag:CCChartSegmentStartTag + selectedIndex];
    NSAssert(button, @"按钮初始化错误");
    [self event_segmentButtonClicked:button];
}

- (void)setSelectedButton:(UIButton *)selectedButton {
    /// 如果点击了同一个按钮, 直接return
    if (_selectedButton == selectedButton) {
        return;
    }
    /// 当indicatorView的button的tag大于2100, 且小于2104时, 表示是MA, EMA, BOLL和关闭, 这几个按钮
    if (selectedButton.tag >= 2100 && selectedButton.tag < 2104) {
        [_secondLevelSelectedButton1 setSelected:NO];
        [selectedButton setSelected:YES];
        _secondLevelSelectedButton1 = selectedButton;
    }
    /// 当indicatorView的button的tag大于等于2103时, 表示是MACD, KDJ, RSI, WR这几个按钮
    else if (selectedButton.tag >= 2103) {
        [_secondLevelSelectedButton2 setSelected:NO];
        [selectedButton setSelected:YES];
        _secondLevelSelectedButton2 = selectedButton;
    }
    /// 其余的表示一直显示的按钮.
    else if (selectedButton.tag != CCChartSegmentStartTag) {
        [_selectedButton setSelected:NO];
        [selectedButton setSelected:YES];
        _selectedButton = selectedButton;
    }
    _selectedIndex = selectedButton.tag - CCChartSegmentStartTag;
    /// indicatorView要动画显示出来
    if (_selectedIndex == 0 && self.indicatorView.frame.origin.x < 0) {
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(self);
        }];
        [UIView animateWithDuration:0.2f animations:^{
            [self layoutIfNeeded];
        }];
    }
    /// indicatorView要动画消失
    else {
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self);
            make.right.mas_equalTo(self.mas_left);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(self);
        }];
        [UIView animateWithDuration:0.2f animations:^{
            [self layoutIfNeeded];
        }];
    }
    [self layoutIfNeeded];
}

#pragma mark - 私有方法
#pragma mark - 创建底部按钮
- (UIButton *)private_createButtonWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:UIColor.mainTextColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.line2Color forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.tag = tag;
    [button addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

#pragma mark - 底部按钮点击事件
- (void)event_segmentButtonClicked:(UIButton *)button {
    /// 调用一个setSelectedButton的方法
    self.selectedButton = button;
    if (button.tag == CCChartSegmentStartTag) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chartSegmentView:clickSegmentButtonIndex:)]) {
        [self.delegate chartSegmentView:self clickSegmentButtonIndex:button.tag - CCChartSegmentStartTag];
    }
}

@end
