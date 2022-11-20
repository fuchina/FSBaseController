//
//  FSConfigCOSController.h
//  FSTututu
//
//  Created by 扶冬冬 on 2022/6/15.
//

#import "FSBaseController.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *_appCfg_cosConfig          = @"cosConfig";                     // cos配置（腾讯云）

@interface FSConfigCOSController : FSBaseController

+ (BOOL)configOSS:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
