//
//  Post.h
//  toy-sns-service
//
//  Created by 김도훈 on 11/9/23.
//

#import <Foundation/Foundation.h>
@import FirebaseCore;
@import FirebaseFirestore;

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSObject

@property (nonatomic, nullable, copy) NSString *identifier;
@property (nonatomic, nullable, copy) NSString *title;
@property (nonatomic, nullable, copy) NSString *content;
@property (nonatomic, nullable, copy) NSString *image;
@property (nonatomic, nullable, copy) NSDate *createdAt;
@property (nonatomic, nullable, copy) NSDate *updatedAt;

@property (nonatomic, nullable, copy) FIRDocumentReference *firebaseRef;

#pragma mark 생성자
/// 스냅샷으로 생성자 만들기
/// - Parameter document: 
- (instancetype)initWithSnapshot:(FIRDocumentSnapshot *)document;

#pragma mark class method
/// 스냅샷을 받으면 생성된 포스트 배열을 반환
/// - Parameter snapshot: 
+ (NSMutableArray<Post *> *)fromFIRQuerySnapshot:(FIRQuerySnapshot *)snapshot;

@end

NS_ASSUME_NONNULL_END
