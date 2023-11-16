//
//  PhotoCollectionViewCell.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/16/23.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    _photoImageView.sd_imageTransition = SDWebImageTransition.fadeTransition;
    _photoImageView.sd_imageIndicator = SDWebImageProgressIndicator.defaultIndicator;
    _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_checkImageView setHidden:YES];
}

- (void)configureCell:(USPhoto *)cellData selected:(NSString *)selectedImgUrlString {
    NSLog(@"%s, line: %d, cellData.identifier: %@",__func__, __LINE__, cellData.identifier);
    
    _cellData = cellData;
    
    NSURL *imgUrl = [[NSURL alloc] initWithString:cellData.urls.regular];
    
    [_photoImageView sd_setImageWithURL:imgUrl];
    [_checkImageView setHidden: ![self isSelected: selectedImgUrlString]];
    
}

- (BOOL)isSelected:(NSString *)selectedImgUrlString {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    return [selectedImgUrlString isEqualToString:_cellData.urls.regular];
}

@end
