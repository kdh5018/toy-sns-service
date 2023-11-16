//
//  USPhotoSearchResponse.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import "USPhotoSearchResponse.h"

@implementation USPhotoSearchResponse

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)jsonDictionary
{
    self = [super init];
    
    if (self) {
        _total      = [jsonDictionary[@"total"] integerValue];
        _totalPages = [jsonDictionary[@"total_page"] integerValue];
        
        NSMutableArray<USPhoto *> *photoList = [[NSMutableArray alloc] init];
        
        for (NSDictionary * aPhotoDictionary in jsonDictionary[@"results"]) {
            USPhoto * aPhoto = [[USPhoto alloc] initWithDictionary:aPhotoDictionary];
            [photoList addObject:aPhoto];
        }
        
        _results = photoList;
    }
    return self;
}

@end
