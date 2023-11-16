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
    NSString *_currentSearchTerm;
    NSMutableArray<USPhoto *> * _photoList;
    NSString *_selectedImgUrlString;
    BOOL _isLoading;
}

@property (weak, nonatomic) IBOutlet UISearchBar *photoSearchBar;
@property (strong, nullable) dispatch_block_t debounceSearchInputTask;
@property (weak, nonatomic) IBOutlet UICollectionView *photoListCollectionView;


@end

@implementation SelectUnsplashPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initialSetting];
    
}

- (void)initialSetting {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    
    _photoSearchBar.delegate = self;
    _currentPage = [[NSNumber alloc] initWithInt:1];
    _currentSearchTerm = @"";
    _isLoading = NO;
    
    [self setCollectionView];
}

- (void)setCollectionView {
    _photoListCollectionView.dataSource = self;
    _photoListCollectionView.delegate = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_photoListCollectionView setCollectionViewLayout:flowLayout];
    [_photoListCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [_photoListCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    UINib *cellNib = [UINib nibWithNibName:PhotoCollectionViewCell.reuseIdentifier bundle:nil];
    [_photoListCollectionView registerNib:cellNib forCellWithReuseIdentifier:PhotoCollectionViewCell.reuseIdentifier];
}

- (IBAction)onDismissBtnClicked:(UIBarButtonItem *)sender {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onPhotoSelectFinished:(UIBarButtonItem *)sender {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    
    if (_photoSelectionBlock == nil) { return; }
    
    if (_selectedImgUrlString == nil) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"안내"
                                       message:@"이미지를 선택해주세요"
                                       preferredStyle:UIAlertControllerStyleAlert];
         
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];
         
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    _photoSelectionBlock(_selectedImgUrlString);
    
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
        
        self->_currentPage = [NSNumber numberWithInt:1];
        
        self->_currentSearchTerm = searchText;
        
        [self searchPhotoApiCall:searchText withPage:self->_currentPage withCompletion:^(USPhotoSearchResponse *response) {
            NSLog(@"%s, line: %d, response.result.count: %d",__func__, __LINE__, [response.results count]);
            self->_photoList = response.results;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_photoListCollectionView reloadData];
            });
        }];
    });
    
    _debounceSearchInputTask = task;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC), dispatch_get_main_queue(), task);
}

- (void)searchPhotoApiCall:(NSString *)searchTerm
                  withPage:(NSNumber *)page
            withCompletion:(void (^)(USPhotoSearchResponse *))completion
{
    NSLog(@"%s, line: %d, searchTerm: %@",__func__, __LINE__, searchTerm);
    
    if (_isLoading) {
        return;
    }
    
    _isLoading = YES;
    
    // 1. 요청 만들기
    // 2. 응답 받기
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLComponents *components = [NSURLComponents new];
    [components setScheme:@"https"];
    [components setHost:@"api.unsplash.com"];
    [components setPath:@"/search/photos"];
    
    NSMutableArray<NSURLQueryItem *> *queries = [NSMutableArray arrayWithCapacity:2];
    
    NSString *pageString = [@([page integerValue]) stringValue];
    [queries addObject:[NSURLQueryItem queryItemWithName:@"page" value:pageString]];
    [queries addObject:[NSURLQueryItem queryItemWithName:@"query" value:searchTerm]];
    
    [components setQueryItems:queries];

    NSURL *url = [components URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"Client-ID rj4H8IRxz6ZrPL0Z7T_UCTMXztElsIZ9U0AZTtOmT_U" forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"에러발생");
            self->_isLoading = NO;
            return;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        // json dictionary -> 데이터 response
        USPhotoSearchResponse * photoListResponse = [[USPhotoSearchResponse alloc] initWithDictionary:json];
        
        self->_isLoading = NO;

        completion(photoListResponse);
    }];
    
    [dataTask resume];
}

#pragma mark UICollectionView FlowLayout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = UIScreen.mainScreen.bounds.size.width / 2 - (20);
    CGFloat height = width * 1.5;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    
    if ([_selectedImgUrlString isEqualToString:_photoList[indexPath.item].urls.regular]) {
        _selectedImgUrlString = nil;
    } else {
        // 1. 선택된 아이템의 url 스트링 가져오기
        _selectedImgUrlString = _photoList[indexPath.item].urls.regular;
    }
    [collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    
    if ([scrollView reachedBottom:200]) {
        NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"바닥");
        _currentPage = [NSNumber numberWithInt: [_currentPage integerValue] + 1];
        [self searchPhotoApiCall:_currentSearchTerm 
                        withPage:_currentPage
                  withCompletion:^(USPhotoSearchResponse * response) {
            NSLog(@"%s, line: %d, response.count: %d",__func__, __LINE__, response.results.count);
            [self->_photoList addObjectsFromArray:response.results];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_photoListCollectionView reloadData];
            });
        }];
    }
}

#pragma mark UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    return _photoList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    USPhoto *cellData = [_photoList objectAtIndex:indexPath.item];
    
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionViewCell.reuseIdentifier forIndexPath:indexPath];
    
    [cell configureCell:cellData selected:_selectedImgUrlString];
    
    return cell;
    
}

@end
