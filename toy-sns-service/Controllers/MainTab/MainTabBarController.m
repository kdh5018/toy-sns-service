//
//  MainTabBarController.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/9/23.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
}

#pragma mark UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    if ([viewController isKindOfClass:[AddPostViewController class]]) {
        
        // AddPostViewController 생성해서 present 시키기
        [AddPostViewController present:self];
        
        return NO;
    }
    return YES;
}

@end
