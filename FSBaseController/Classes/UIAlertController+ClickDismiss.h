//
//  UIAlertController+ClickDismiss.h
//  FSBaseController
//
//  Created by 扶冬冬 on 2024/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (ClickDismiss)

- (BOOL)addTapEvent:(void (^)(UIAlertController *controller))clickDismiss;

@end

NS_ASSUME_NONNULL_END
