//
//  USPhoto.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import "USPhoto.h"

@implementation USPhoto

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)jsonDictionary
{
    self = [super init];
    
    if (self) {
        _identifier = jsonDictionary[@"id"] ?: @"";
        _urls = [[USUrls alloc] initWithDictionary:jsonDictionary[@"urls"]];
    }
    
    return self;
}


@end
