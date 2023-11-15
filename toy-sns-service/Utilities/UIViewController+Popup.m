//
//  UIViewController+Popup.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/10/23.
//

#import "UIViewController+Popup.h"

@implementation UIViewController (Popup)

+ (void)present:(UIViewController *)caller {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    
    NSString *className =  NSStringFromClass([self class]);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:className bundle:nil];
    UIViewController *popupVC = [storyboard instantiateViewControllerWithIdentifier:className];
    
    [popupVC setModalPresentationStyle: UIModalPresentationFullScreen];
    
    [caller presentViewController:popupVC animated:YES completion:nil];
}

+ (void)presentWithNavigation:(UIViewController *)caller {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    
    NSString *className =  NSStringFromClass([self class]);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:className bundle:nil];
    UIViewController *popupVC = [storyboard instantiateViewControllerWithIdentifier:className];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:popupVC];
    
    [navController setModalPresentationStyle: UIModalPresentationFullScreen];
    
    [caller presentViewController:navController animated:YES completion:nil];
}

@end
