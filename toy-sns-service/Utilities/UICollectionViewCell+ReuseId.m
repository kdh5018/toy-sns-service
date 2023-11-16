//
//  UICollectionViewCell+ReuseId.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import "UICollectionViewCell+ReuseId.h"

@implementation UICollectionViewCell (ReuseId)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
