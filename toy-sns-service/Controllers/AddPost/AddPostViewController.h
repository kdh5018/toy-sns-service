//
//  AddPostViewController.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/9/23.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Constants.h"
#import "SelectUnsplashPhotoViewController.h"
#import "UIViewController+Popup.h"
@import FirebaseCore;
@import FirebaseFirestore;

NS_ASSUME_NONNULL_BEGIN

@interface AddPostViewController : UIViewController

//+ (void)present:(UIViewController *)caller;

@end

NS_ASSUME_NONNULL_END
