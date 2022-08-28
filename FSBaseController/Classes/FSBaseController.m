//
//  FSBaseController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseController.h"

@interface FSBaseController ()

@property (nonatomic,strong) UIView                     *baseLoadingView;
@property (nonatomic,strong) UIView                     *baseBackView;

@end

@implementation FSBaseController{
    BOOL        _onceBase;
    BOOL        _onceBase_viewWillAppear;
    UIView      *_backTapView;
    BOOL        _baseComponentAmounted;
}

- (void)dealloc{
#if TARGET_IPHONE_SIMULATOR
    NSString *title = [[NSString alloc] initWithFormat:@"%@ dealloc",NSStringFromClass(self.class)];
    NSLog(@"%@",title);
#else
#endif
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_onceBase_viewWillAppear) {
        _onceBase_viewWillAppear = YES;
        
        // translucent为YES，self.view布局从屏幕顶部(0,0)开始，如果为NO会从导航栏底部开始
        self.navigationController.navigationBar.translucent = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_onceBase) {
        _onceBase = YES;
        
        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:FSKit.appName style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.navigationBar.topItem.backBarButtonItem.tintColor = self.view.tintColor;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [FSTrack event:NSStringFromClass([self class])];
    self.view.backgroundColor = RGBCOLOR(245, 245, 245, 1);
    
    _backTapView = [FSViewManager viewWithFrame:self.view.bounds backColor:nil];
    [self.view addSubview:_backTapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionBase)];
    [_backTapView addGestureRecognizer:tap];
}

- (void)fitIOS15 {
    if (@available(iOS 15.0, *)) {
        // UINavigationBar
        UINavigationBarAppearance *navigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        navigationBarAppearance.backgroundColor = UIColor.whiteColor;
        self.navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance;
        self.navigationController.navigationBar.standardAppearance = navigationBarAppearance;

        // UIToolbar
        UIToolbarAppearance *toolBarAppearance = [[UIToolbarAppearance alloc] init];
        toolBarAppearance.backgroundColor = UIColor.whiteColor;
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000
        self.navigationController.toolbar.scrollEdgeAppearance = toolBarAppearance;
#endif
        self.navigationController.toolbar.standardAppearance = toolBarAppearance;

        // UITabBar
        UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
        toolBarAppearance.backgroundColor = UIColor.whiteColor;
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000
        self.tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance;
#endif
        self.tabBarController.tabBar.standardAppearance = tabBarAppearance;
    }
}

- (Class)baseManagerClass {
    return nil;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!_baseComponentAmounted) {
        _baseComponentAmounted = YES;
        
        Class cls = [self baseManagerClass];
        if (cls) {
            __block id baseMngr = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                baseMngr = [[cls alloc] init];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.manager = baseMngr;
                    [self componentWillMount];
                });
            });
        } else {
            [self componentWillMount];
        }
    }
}

- (void)componentWillMount {}
- (void)renderBeforeRequest {}
- (void)requestServerData {}

- (void)tapActionBase{
    [self.view endEditing:YES];
}

- (FSTapScrollView *)scrollView {
    if (!_scrollView) {
        // 纵坐标即使为0，子视图也是从导航栏下面开始布局
        _scrollView = [[FSTapScrollView alloc] initWithFrame:CGRectMake(0, self.view.safeAreaInsets_fs.top, WIDTHFC, HEIGHTFC - self.view.safeAreaInsets_fs.top)];
        _scrollView.contentSize = CGSizeMake(WIDTHFC, HEIGHTFC + 10);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delaysContentTouches = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (_backTapView) {
            [self.view insertSubview:_scrollView aboveSubview:_backTapView];
        }else{
            [self.view addSubview:_scrollView];
        }
        __weak typeof(self)this = self;
        _scrollView.click = ^(FSTapScrollView *view) {
            [this tapActionBase];
        };
    }
    return _scrollView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)showWaitView:(BOOL)show {
    if (show) {
        CGFloat blackWidth = 80;
        CGRect blackRect = CGRectMake(WIDTHFC / 2 - 40, HEIGHTFC / 2 - 40, blackWidth, blackWidth);
        if (_baseLoadingView) {
            [self.view bringSubviewToFront:_baseLoadingView];
            _baseLoadingView.frame = [UIScreen mainScreen].bounds;
            _baseBackView.frame = blackRect;
        }else{
            _baseLoadingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [self.view insertSubview:_baseLoadingView atIndex:self.view.subviews.count];
            
            _baseBackView = [[UIView alloc] initWithFrame:blackRect];
            _baseBackView.alpha = .7;
            _baseBackView.backgroundColor = [UIColor blackColor];
            _baseBackView.layer.cornerRadius = 6;
            [_baseLoadingView addSubview:_baseBackView];
            
            UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            active.frame = CGRectMake(0, 0, _baseBackView.width, _baseBackView.height);
            [active startAnimating];
            [_baseBackView addSubview:active];
        }
    }else{
        [_baseLoadingView removeFromSuperview];
        _baseLoadingView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // TODO 埋点，记录页面收到内存警告
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
