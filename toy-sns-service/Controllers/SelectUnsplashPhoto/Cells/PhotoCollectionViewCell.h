//
//  PhotoCollectionViewCell.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import <UIKit/UIKit.h>
#import "USPhoto.h"
@import SDWebImage;

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@property(weak, nonatomic, nullable) USPhoto *cellData;

#pragma mark Instance Method
- (void)configureCell:(USPhoto *)cellData selected:(NSString *)selectedImgUrlString;

@end

NS_ASSUME_NONNULL_END
