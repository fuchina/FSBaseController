//
//  FSPageController.m
//  FSBaseController
//
//  Created by FudonFuchina on 2019/8/18.
//

#import "FSPageController.h"

@interface FSPageController ()

@end

@implementation FSPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pageDesignViews];
}

- (void)pageDesignViews {
    self.view.backgroundColor = UIColor.whiteColor;
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
