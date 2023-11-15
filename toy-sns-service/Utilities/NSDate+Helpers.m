//
//  NSDate+Helpers.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/9/23.
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

- (NSString *)toString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY년 MM월 dd일 HH시 mm분"];
    
    NSString * dateString = [formatter stringFromDate:self];
    return dateString;
}

@end
