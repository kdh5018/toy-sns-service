//
//  USPhoto.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import <Foundation/Foundation.h>
#import "USUrls.h"

NS_ASSUME_NONNULL_BEGIN

@interface USPhoto : NSObject

@property (nonatomic, nullable, copy) NSString * identifier;
@property (nonatomic, nullable, copy) USUrls * urls;
@property (nonatomic, nullable, copy) NSString * full;

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)jsonDictionary;

@end

NS_ASSUME_NONNULL_END
