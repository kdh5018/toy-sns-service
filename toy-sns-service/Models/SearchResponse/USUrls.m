//
//  USUrls.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import "USUrls.h"

@implementation USUrls

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)jsonDictionary
{
    self = [super init];
    
    if (self) {
        _regular    = jsonDictionary[@"regular"] ?: @"";
        _small      = jsonDictionary[@"small"] ?: @"";
        _full       = jsonDictionary[@"full"] ?: @"";
    }
    return self;
}

@end
