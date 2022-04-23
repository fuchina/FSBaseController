//
//  FSBaseController.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSNavigationController.h"
#import "FSTapScrollView.h"
#import "FSViewManager.h"
#import "UIViewExt.h"
#import "FuSoft.h"
#import "FSKit.h"
#import "FSTrack.h"
#import "FSApp.h"
#import "FSBaseManager.h"

@interface FSBaseController : UIViewController

/*
    这个方法的作用会把整个App的状态栏都改变。
    另一种方法：@property(nonatomic, readonly) UIStatusBarStyle preferredStatusBarStyle NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED; // Defaults to UIStatusBarStyleDefault
 如果UIViewController 不在导航控制器中，这个方法才有效；如果在导航控制器中，需要在导航控制器中调用这个方法，UIViewController中调用这个方法    self.navigationController.navigationBar.barStyle = UIBarStyleBlack来改变。

 */
@property (nonatomic,assign) BOOL               letStatusBarWhite;  // 把整个App都变了

@property (nonatomic,strong) FSTapScrollView    *scrollView;

// manager继承自FSBaseManager，在子线程中执行
- (Class)baseManagerClass;
@property (nonatomic, strong) FSBaseManager     *manager;

- (void)showWaitView:(BOOL)show;

// UI创建入口，此时能获取安全区边际参数
- (void)componentWillMount;

// 网络请求前调用
- (void)renderBeforeRequest;

// 开始网络请求
- (void)requestServerData;

@end
