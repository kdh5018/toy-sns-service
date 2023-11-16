//
//  USUrls.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USUrls : NSObject

@property (nonatomic, nullable, copy) NSString * regular;
@property (nonatomic, nullable, copy) NSString * small;
@property (nonatomic, nullable, copy) NSString * full;

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)jsonDictionary;

@end

NS_ASSUME_NONNULL_END
