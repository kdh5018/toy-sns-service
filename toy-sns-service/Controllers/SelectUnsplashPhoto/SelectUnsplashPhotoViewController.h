//
//  SelectUnsplashPhotoViewController.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/15/23.
//

#import <UIKit/UIKit.h>
#import "USPhotoSearchResponse.h"
#import "PhotoCollectionViewCell.h"
#import "UICollectionViewCell+ReuseId.h"
#import "UIScrollView+Helpers.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectUnsplashPhotoViewController : UIViewController <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, nullable, copy) void(^photoSelectionBlock)(NSString *);

@end

NS_ASSUME_NONNULL_END
