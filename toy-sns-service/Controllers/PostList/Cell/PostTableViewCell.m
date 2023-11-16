//
//  PostTableViewCell.m
//  toy-sns-service
//
//  Created by 김도훈 on 11/9/23.
//

#import "PostTableViewCell.h"
#import "NSDate+Helpers.h"

@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(Post *)cellData {
    NSLog(@"%s, line: %d, %@",__func__, __LINE__, @"");
    
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:cellData.image]
                 placeholderImage:[UIImage systemImageNamed:@"photo.fill.on.rectangle.fill"]];
    
    NSString *idString = [@"아이디: " stringByAppendingString:cellData.identifier];
    [_identifierLabel setText:idString];
    
    NSString *titleString = [@"제목: " stringByAppendingString:cellData.title];
    [_titleLabel setText:titleString];
    
    NSString *contentString = [@"내용: " stringByAppendingString:cellData.content];
    [_contentLabel setText:contentString];
    
    NSString *createdAtString = [@"최초 작성일: " stringByAppendingString:[cellData.createdAt toString]];
    [_createdLabel setText:createdAtString];
    
    NSString *updatedAtString = [@"마지막 수정일: " stringByAppendingString:[cellData.updatedAt toString]];
    [_updatedLabel setText:updatedAtString];
    
}

@end
