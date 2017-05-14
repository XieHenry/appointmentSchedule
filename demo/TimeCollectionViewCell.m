//
//  TimeCollectionViewCell.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/10.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "TimeCollectionViewCell.h"

@implementation TimeCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
//        self.timeLabel.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.timeLabel];
    }
    
    return self;
}

@end
