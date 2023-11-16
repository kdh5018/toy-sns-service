//
//  ViewController.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/8/23.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "PostTableViewCell.h"
#import "Constants.h"
#import "UITableViewCell+ReuseId.h"
@import FirebaseCore;
@import FirebaseFirestore;


@interface PostListViewController : UIViewController <UITableViewDataSource>



@end

