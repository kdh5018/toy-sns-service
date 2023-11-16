//
//  USPhotoSearchResponse.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import <Foundation/Foundation.h>
#import "USPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@interface USPhotoSearchResponse : NSObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, nullable, copy) NSMutableArray<USPhoto *> * results;

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)jsonDictionary;

@end

NS_ASSUME_NONNULL_END
