//
//  ViewController.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/8/23.
//

#import "PostListViewController.h"

@interface PostListViewController ()
{
    NSMutableArray<Post *> *_postList;
}

// nonatomic을 사용하면 동작이 조금 더 빨라짐
@property (weak, nonatomic, nullable) FIRFirestore *db;

@end

@implementation PostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _db = [FIRFirestore firestore];
    
    __weak PostListViewController *weakSelf = self;
    
#pragma mark 데이터 조회
        [[[_db collectionWithPath:@"posts"] queryOrderedByField:@"updated_at" descending:YES]
            getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
              if (error != nil) {
                NSLog(@"Error getting documents: %@", error);
              } else {
                  PostListViewController *strongSelf = weakSelf;
                  if (strongSelf) {
                      strongSelf->_postList = [Post fromFIRQuerySnapshot:snapshot];
                  }
              }
            }];
    
#pragma mark 데이터 추가
    FIRDocumentReference *newPostRef = [[_db collectionWithPath:@"posts"] documentWithAutoID];
    NSDictionary *newPostDictionary = @{
        @"identifier": newPostRef.documentID,
        @"title": @"타이틀",
        @"content": @"내용",
        @"image":@"https://plus.unsplash.com/premium_photo-1699372281371-72909c172533?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxMHx8fGVufDB8fHx8fA%3D%3D",
        @"created_at": [FIRTimestamp timestampWithDate:[NSDate date]],
        @"updated_at": [FIRTimestamp timestampWithDate:[NSDate date]],
    };
    
    [newPostRef setData:newPostDictionary completion:^(NSError * _Nullable error) {
        NSLog(@"%s, line: %d, %@",__func__, __LINE__, [error localizedDescription]);
        if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
        } else {
            NSLog(@"포스팅 추가 성공: %@", newPostRef.documentID);
        }
    }];
    
#pragma mark 데이터 수정
    
            NSDictionary *updatedPostDictionary = @{
              @"identifier": newPostRef.documentID,
              @"title": @"타이틀 - 수정 완료",
              @"content": @"내용 - 수정 완료",
              @"updated_at": [FIRTimestamp timestampWithDate:[NSDate date]],
            };
    
        FIRDocumentReference *postUpdateRef = [[_db collectionWithPath:@"posts"]
                                                documentWithPath:@"p7PTfxGs3tIWp047jAx5"];
    
        [postUpdateRef updateData:updatedPostDictionary completion:^(NSError * _Nullable error) {
            if (error != nil) {
              NSLog(@"Error updating document: %@", error);
            } else {
              NSLog(@"Document successfully updated");
            }
        }];
    
#pragma mark 데이터 삭제
    
    FIRDocumentReference *postDeleteRef = [[_db collectionWithPath:@"posts"]
                                            documentWithPath:@"p7PTfxGs3tIWp047jAx5"];
    
    [postDeleteRef deleteDocumentWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error removing document: %@", error);
        } else {
            NSLog(@"Document successfully removed!");
        }
    }];
}


@end
