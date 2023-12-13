//
//  AddPostViewController.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/9/23.
//

#import "AddPostViewController.h"
#import "PostListViewController.h"


@interface AddPostViewController ()
{
    NSString *_selectedImgUrlString;
}

@property (weak, nonatomic, nullable) FIRFirestore *db;

@property (weak, nonatomic) IBOutlet UITextField *titleInputTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentInputTextField;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

// 각종 UI 설정을 위한 Outlet 설정
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *addPostButton;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UITextView *inputView;

@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _db = [FIRFirestore firestore];
    
    [self setupUI];
    
    _postImageView.sd_imageTransition = SDWebImageTransition.fadeTransition;
    _postImageView.sd_imageIndicator = SDWebImageProgressIndicator.defaultIndicator;
    _postImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setupUI {
    
    _dismissButton.layer.borderWidth = 1;
    _dismissButton.layer.borderColor = UIColor.blackColor.CGColor;
    _dismissButton.layer.cornerRadius = 8;
    
    _addPostButton.layer.borderWidth = 1;
    _addPostButton.layer.borderColor = UIColor.blackColor.CGColor;
    _addPostButton.layer.cornerRadius = 8;
    
    _selectImageButton.layer.borderWidth = 1;
    _selectImageButton.layer.borderColor = UIColor.blackColor.CGColor;
    _selectImageButton.layer.cornerRadius = 8;
    
    _inputView.layer.borderWidth = 1;
    _inputView.layer.borderColor = UIColor.blackColor.CGColor;
    _inputView.layer.cornerRadius = 8;
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
    
    [self addPost:titleInput 
      withContent:contentInput
     withImageUrl:_selectedImgUrlString ?: @""
   withcompletion:^{
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
    
//    [SelectUnsplashPhotoViewController presentWithNavigation:self];
    SelectUnsplashPhotoViewController *selectPhotoVC = (SelectUnsplashPhotoViewController *)[SelectUnsplashPhotoViewController presentWithNavigationAndReturnVC:self];
    
    selectPhotoVC.photoSelectionBlock = ^(NSString * selectedImgUrl){
        NSLog(@"%s, line: %d, selectedImgUrl: %@",__func__, __LINE__, selectedImgUrl);
        
        self->_selectedImgUrlString = selectedImgUrl;
        
        NSURL *imgUrl = [[NSURL alloc] initWithString:selectedImgUrl];
        [self->_postImageView sd_setImageWithURL:imgUrl];
    };
    
}

#pragma mark 데이터 추가
- (void)addPost:(NSString *)title
    withContent:(NSString *)content
   withImageUrl:(NSString *)imageUrlString
 withcompletion:(void(^)(void))completion {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    FIRDocumentReference *newPostRef = [[_db collectionWithPath:@"posts"] documentWithAutoID];
    NSDictionary *newPostDictionary = @{
        @"identifier": newPostRef.documentID,
        @"title": title,
        @"content": content,
        @"image":imageUrlString,
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
