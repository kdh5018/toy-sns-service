//
//  PostTableViewCell.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/9/23.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import SDWebImage;

NS_ASSUME_NONNULL_BEGIN

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedLabel;

#pragma makr Instance Method
- (void)configureCell:(Post *)cellData;

#pragma mark Class Methods
+ (NSString *)cellReuseIdentifier;
@end

NS_ASSUME_NONNULL_END
