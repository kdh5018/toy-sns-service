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

@property (weak, nonatomic) IBOutlet UITableView *postListTableView;

@end

@implementation PostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialSetting];
    
    __weak PostListViewController *weakSelf = self;
    
    [self fetchPosts:^(NSMutableArray<Post *> *fetchedPosts) {
        PostListViewController * strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf->_postList = fetchedPosts;
            [strongSelf->_postListTableView reloadData];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:PostListVCShouldFetchListNotification object:nil];
}

- (void)dealloc
{
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostListVCShouldFetchListNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:PostListVCShouldFetchListNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostListVCShouldFetchListNotification object:nil];
}

#pragma mark UITableViewDataSource 관련

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    return _postList.count ?: 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s, line: %d, indexPath.row: %d",__func__, __LINE__, indexPath.row);
    Post *cellData = [_postList objectAtIndex:indexPath.row];
    
    PostTableViewCell *cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PostTableViewCell.cellReuseIdentifier forIndexPath:indexPath];
    
    [cell configureCell:cellData];
    
    return cell;
}

#pragma mark 포스트 데이터 관련
- (void)initialSetting {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    _db = [FIRFirestore firestore];
    
    _postListTableView.dataSource = self;
    
    UINib * postCellNib = [UINib nibWithNibName:@"PostTableViewCell" bundle:nil];
    [_postListTableView registerNib:postCellNib forCellReuseIdentifier:PostTableViewCell.cellReuseIdentifier];
}

#pragma mark Selector Action
- (void)handleNotification:(NSNotification *)notification {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    if ([[notification name] isEqualToString:PostListVCShouldFetchListNotification]) {
        [self fetchPosts:^(NSMutableArray<Post *> *fetchedPosts) {
            __weak PostListViewController *weakSelf = self;
            
            PostListViewController * strongSelf = weakSelf;
            
            if (strongSelf) {
                strongSelf->_postList = fetchedPosts;
                [strongSelf->_postListTableView reloadData];
            }
        }];
    }
}

#pragma mark 데이터 조회
- (void)fetchPosts:(void(^)(NSMutableArray<Post *> *))completion {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    __weak PostListViewController *weakSelf = self;
    
    [[[_db collectionWithPath:@"posts"] queryOrderedByField:@"updated_at" descending:YES]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
        
        NSMutableArray<Post *> * tempPostList = [[NSMutableArray alloc] init];
        
        if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
        } else {
            tempPostList = [Post fromFIRQuerySnapshot:snapshot];
            completion(tempPostList);
            //                  PostListViewController *strongSelf = weakSelf;
            //                  if (strongSelf) {
            //                      strongSelf->_postList = [Post fromFIRQuerySnapshot:snapshot];
            //                  }
        }
    }];
}

#pragma mark 데이터 수정
- (void)editPost:(FIRDocumentReference *)postRef {
    NSDictionary *updatedPostDictionary = @{
        @"identifier": postRef.documentID,
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
}

#pragma mark 데이터 삭제
- (void)deletePost:(NSString *)postIdentifier {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    FIRDocumentReference *postDeleteRef = [[_db collectionWithPath:@"posts"]
                                           documentWithPath:postIdentifier];
    
    [postDeleteRef deleteDocumentWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error removing document: %@", error);
        } else {
            NSLog(@"Document successfully removed!");
        }
    }];
}
@end
