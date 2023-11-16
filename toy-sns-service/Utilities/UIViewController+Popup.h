//
//  UIViewController+Popup.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Popup)

+ (void)present:(UIViewController *)caller;

+ (void)presentWithNavigation:(UIViewController *)caller;

+ (instancetype)presentWithNavigationAndReturnVC:(UIViewController *)caller;

@end

NS_ASSUME_NONNULL_END
