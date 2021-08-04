//
//  CCChartViewController.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import "CCChartViewController.h"

@interface CCChartViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation CCChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
    }
    return _indicatorView;
}
@end
