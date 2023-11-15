//
//  AddPostViewController.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/9/23.
//

#import "AddPostViewController.h"
#import "PostListViewController.h"


@interface AddPostViewController ()

@property (weak, nonatomic, nullable) FIRFirestore *db;

@property (weak, nonatomic) IBOutlet UITextField *titleInputTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentInputTextField;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _db = [FIRFirestore firestore];
}

#pragma mark IBActions

/// 닫기 버튼 클릭
/// - Parameter sender:
- (IBAction)onDismissBtnClicked:(UIButton *)sender {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 포스트 등록 버튼 클릭
/// - Parameter sender:
- (IBAction)onAddPostBtnClicked:(UIButton *)sender {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    NSString *titleInput = _titleInputTextField.text ?: @"";
    NSString *contentInput = _contentInputTextField.text ?: @"";
    
    __weak AddPostViewController *weakSelf = self;
    
    [self addPost:titleInput withContent:contentInput withcompletion:^{
        NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"포스트 완료");
        
        AddPostViewController *strongSelf = weakSelf;
        
        if (strongSelf) {
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
            
        }
    }];
}

/// 포스트 사진 선택 클릭
/// - Parameter sender:
- (IBAction)onPhotoSelectBtnClicked:(UIButton *)sender {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    
    [SelectUnsplashPhotoViewController presentWithNavigation:self];
    
}

#pragma mark 데이터 추가
- (void)addPost:(NSString *)title
    withContent:(NSString *)content
 withcompletion:(void(^)(void))completion {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    FIRDocumentReference *newPostRef = [[_db collectionWithPath:@"posts"] documentWithAutoID];
    NSDictionary *newPostDictionary = @{
        @"identifier": newPostRef.documentID,
        @"title": title,
        @"content": content,
        @"image":@"https://images.unsplash.com/photo-1695653422909-20d8cc35ca2e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxMXx8fGVufDB8fHx8fA%3D%3D",
        @"created_at": [FIRTimestamp timestampWithDate:[NSDate date]],
        @"updated_at": [FIRTimestamp timestampWithDate:[NSDate date]],
    };
    
    [newPostRef setData:newPostDictionary completion:^(NSError * _Nullable error) {
        NSLog(@"%s, line: %d, %@",__func__, __LINE__, [error localizedDescription]);
        if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
        } else {
            NSLog(@"포스팅 추가 성공");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PostListVCShouldFetchListNotification object:self];
            
            completion();
        }
    }];
}

//#pragma mark Class Methods
//+ (void)present:(UIViewController *)caller {
//    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
//
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddPostViewController" bundle:nil];
//    UIViewController *addPostVC = [storyboard instantiateViewControllerWithIdentifier:@"AddPostViewController"];
//
//    [addPostVC setModalPresentationStyle: UIModalPresentationFullScreen];
//
//    [caller presentViewController:addPostVC animated:YES completion:nil];
//}

@end
