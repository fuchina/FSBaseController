//
//  FSNavigationController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSNavigationController.h"

@protocol UINavigationControllerPopDelegate <NSObject>

- (BOOL)navigationShouldPopOnBackButton;

@end

@implementation FSNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.topViewController) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    
    [super pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *topController = self.topViewController;
    if ([topController respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        UIViewController<UINavigationControllerPopDelegate> *vc = (UIViewController<UINavigationControllerPopDelegate> *)topController;
        BOOL canPop = [vc navigationShouldPopOnBackButton];
        if (canPop) {
            return [super popViewControllerAnimated:animated];
        } else {
            return nil;
        }
    }
    return [super popViewControllerAnimated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
