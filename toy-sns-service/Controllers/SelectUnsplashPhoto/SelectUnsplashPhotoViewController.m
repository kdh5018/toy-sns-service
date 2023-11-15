//
//  SelectUnsplashPhotoViewController.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/15/23.
//

#import "SelectUnsplashPhotoViewController.h"

@interface SelectUnsplashPhotoViewController ()
{
    NSNumber *_currentPage;
}

@property (weak, nonatomic) IBOutlet UISearchBar *photoSearchBar;
@property (strong, nullable) dispatch_block_t debounceSearchInputTask;

@end

@implementation SelectUnsplashPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _photoSearchBar.delegate = self;
    _currentPage = [[NSNumber alloc] initWithInt:1];
    
}
- (IBAction)onDismissBtnClicked:(UIBarButtonItem *)sender {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onPhotoSelectFinished:(UIBarButtonItem *)sender {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    NSLog(@"%s, line: %d, %@",__func__, __LINE__, searchText);
    
    // 글자 입력시 디바운스 작업 초기화
    if (_debounceSearchInputTask != nil) {
        dispatch_block_cancel(_debounceSearchInputTask);
        _debounceSearchInputTask = nil;
    }
    
    if (searchText.length < 1) {
        return;
    }
    
    dispatch_block_t task = dispatch_block_create_with_qos_class(DISPATCH_BLOCK_ENFORCE_QOS_CLASS, QOS_CLASS_USER_INITIATED, 0, ^{
        NSLog(@"%s, line: %d, 입력된 글자: %@",__func__, __LINE__, searchText);
        
        [self searchPhotoApiCall:searchText withPage:_currentPage];
    });
    
    _debounceSearchInputTask = task;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC), dispatch_get_main_queue(), task);
}

- (void)searchPhotoApiCall:(NSString *)searchTerm
                  withPage:(NSNumber *)page
//            withCompletion:(void (^)(USPhotoSearchResponse *))completion
{
    NSLog(@"%s, line: %d, searchTerm: %@",__func__, __LINE__, searchTerm);
    
    // 1. 요청 만들기
    // 2. 응답 받기
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLComponents *components = [NSURLComponents new];
    [components setScheme:@"https"];
    [components setHost:@"api.unsplash.com"];
    [components setPath:@"/search/photos"];
    [components setQuery:[@"page=" stringByAppendingString:[page stringValue]]];
    [components setQuery:[@"query=" stringByAppendingString:searchTerm]];

    NSURL *url = [components URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"Client-ID rj4H8IRxz6ZrPL0Z7T_UCTMXztElsIZ9U0AZTtOmT_U" forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"에러발생");
            return;
        }

    }];
    
    [dataTask resume];
}

@end
