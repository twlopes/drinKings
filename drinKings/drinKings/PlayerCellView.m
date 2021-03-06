//
//  PlayerCellView.m
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "PlayerCellView.h"

@implementation PlayerCellView

@synthesize player=_player, btnEdit=_btnEdit, btnDelete=_btnDelete, selected=_selected;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    DLog(@"~");
    
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return ( nil );
    
    DLog(@"frame %f %f", frame.size.width, frame.size.height);
    
    _player = [[PlayerImageView alloc] initWithFrame: frame];
    _player.layer.shadowColor = [UIColor blackColor].CGColor;
    _player.layer.shadowOpacity = 0.65;
    _player.layer.shadowOffset = CGSizeMake(0,4);
    _player.layer.shouldRasterize=YES;
    [self.contentView addSubview: _player];
    
    _btnDelete = [GradientButton buttonWithType:UIButtonTypeCustom];
    [_btnDelete useRedDeleteStyle];
    [_btnDelete setTitle:@"X" forState:UIControlStateNormal];
    _btnDelete.frame = CGRectMake(frame.size.width-25, -5, 30, 30);
    _btnDelete.contentEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    _btnDelete.hidden=YES;
    _btnDelete.layer.shadowColor = [UIColor blackColor].CGColor;
    _btnDelete.layer.shadowOpacity = 0.65;
    _btnDelete.layer.shadowOffset = CGSizeMake(0,4);
    [self.contentView addSubview:_btnDelete];
    
    return ( self );
}

//- (void)setSelected:(BOOL)selected{
//    _selected=selected;
    
    /*if(_selected){
        [_player setBackgroundColor:[UIColor blueColor]];
    }else{
        [_player setBackgroundColor:[UIColor whiteColor]];
    }*/
//}

- (CALayer *) glowSelectionLayer
{
    return ( _player.layer );
}

- (UIImage *) image
{
    return ( _player.image.image );
}

- (void) setImage: (UIImage *) anImage
{
    _player.image.image = anImage;
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
     DLog(@"~");
    
    [super layoutSubviews];
    
    /*CGSize imageSize = _player.image.image.size;
    CGRect frame = _player.frame;
    CGRect bounds = self.contentView.bounds;
    
    if ( (imageSize.width <= bounds.size.width) &&
        (imageSize.height <= bounds.size.height) )
    {
        return;
    }
    
    // scale it down to fit
    CGFloat hRatio = bounds.size.width / imageSize.width;
    CGFloat vRatio = bounds.size.height / imageSize.height;
    CGFloat ratio = MAX(hRatio, vRatio);
    
    frame.size.width = floorf(imageSize.width * ratio);
    frame.size.height = floorf(imageSize.height * ratio);
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    frame.origin.y = floorf((bounds.size.height - frame.size.height) * 0.5);
    _player.frame = frame;*/
}

@end
