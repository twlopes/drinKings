//
//  PlayerImage.m
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "PlayerImageView.h"

@implementation PlayerImageView

@synthesize image=_image, name=_name, btnPlayer=_btnPlayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // work out the size of the border based on size
        int border = frame.size.width/20;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(border, border, frame.size.width-(border*2), frame.size.height-(border*2)-(border*5))];
        _image.backgroundColor = [UIColor lightGrayColor];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
        [self addSubview:_image];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(border, _image.frame.size.height+(border*1.5), frame.size.width-(border*2), border*5)];
        _name.font = [UIFont systemFontOfSize:border*2];
        _name.textAlignment = UITextAlignmentCenter;
        _name.backgroundColor = [UIColor clearColor];
        _name.numberOfLines=2;
        [self addSubview:_name];
        
        _btnPlayer = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlayer.frame = frame;
        _btnPlayer.enabled=NO;
        _btnPlayer.backgroundColor = [UIColor clearColor];
        //[self addSubview:_btnPlayer];                                                    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
