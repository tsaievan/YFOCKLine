//
//  CCChartViewController.m
//  CCKLine
//
//  Created by 蔡一凡 on 2021/8/4.
//

#import "CCChartViewController.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_MAX_LENGTH MAX(kScreenWidth, kScreenHeight)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH >= 812.0)
#define defer __strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^

@interface CCChartViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

static void blockCleanUp(__strong void(^*block)(void)) {
    (*block)();
}

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
