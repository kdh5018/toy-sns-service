//
//  UITableViewCell+ReuseId.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import "UITableViewCell+ReuseId.h"

@implementation UITableViewCell (ReuseId)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
