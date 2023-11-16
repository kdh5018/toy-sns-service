//
//  UIScrollView+Helpers.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import "UIScrollView+Helpers.h"

@implementation UIScrollView (Helpers)

- (BOOL)reachedBottom {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    CGFloat height = self.frame.size.height;
    CGFloat contentYOffset = self.contentOffset.y;
    
    CGFloat distanceFromBottom = self.contentSize.height - contentYOffset;
    
    BOOL reachedBottom = distanceFromBottom - 300 < height;

    return reachedBottom;
}

- (BOOL)reachedBottom:(CGFloat)threshhold {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    CGFloat height = self.frame.size.height;
    CGFloat contentYOffset = self.contentOffset.y;
    
    CGFloat distanceFromBottom = self.contentSize.height - contentYOffset;
    
    BOOL reachedBottom = distanceFromBottom - threshhold < height;

    return reachedBottom;
}

@end
