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
#import "FuSoft.h"
#import "FSKit.h"
#import "FSTrack.h"
#import "FSApp.h"
#import "FSView.h"
#import "FSUIAdapter.h"

@interface FSBaseController : UIViewController

+ (void)fitIOS15;

@property (nonatomic, copy)  NSString           *backBarButtonItemTitle;

@property (nonatomic,strong) FSTapScrollView    *scrollView;

- (void)showWaitView:(BOOL)show;

// UI创建入口，此时能获取安全区边际参数
- (void)componentWillMount;

// 开始网络请求
- (void)baseHandleDatas;

// 开始渲染UI
- (void)baseDesignViews;

/**
 *  在有下拉刷新的app里，可以使用
 */
- (void)fitIOS15;

/**
 *  底部视图
 */
- (FSView *)fs_bottomView;

/**
 *  状态栏方向监听及回调
 */
- (void)baseAddBarOrientationChangedNotification;
- (void)baseHandleChangeStatusBarOrientation:(UIInterfaceOrientation)orientation;

/**
 *  tableView cell 反选效果
 */
- (void)configCellDeselectView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

/**
 *  调用componentWillMount / viewDidAppear方法时会被设置为YES，调用viewDidDisappear方法时会被设置为NO；
 *  当push到其他页面的时候，系统调用viewDidAppear方法会有时差，如果在时差内有其他依赖逻辑需要执行，就在push时将其设置为NO，记录标记，在viewDidAppear时继续执行。
 *  当返回到这个页面的时候，系统调用viewDidAppear方法会有时差，如果在时差内有其他依赖逻辑需要执行，就需要在记录标记，在viewDidAppear时继续执行；或者通过回调逻辑将isVisibling设置为YES。
 *
 *  比如，页面在请求网络，不定时返回，请求成功后会弹窗，只有isVisibling为YES时才弹，如果正在请求中，用户push到页面去了，在viewDidAppear调用之前网络回来了，这个时候就会弹出弹窗，这时需要在push那一刻就将isVisibling设置为NO，然后做标记，等页面返回时，再继续逻辑；如果用户正要返回页面，但是在调用viewDidAppear之前，接口请求回来了，会导致这次的弹窗显示不出来，要么通过回调提前将isVisibling设置为YES，要么也是做标记，等页面调viewDidAppear时继续执行。
 */
@property (nonatomic, assign) BOOL                isVisibling;

@end
