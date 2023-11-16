//
//  UIScrollView+Helpers.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Helpers)

- (BOOL)reachedBottom;

- (BOOL)reachedBottom:(CGFloat)threshhold;

@end

NS_ASSUME_NONNULL_END
