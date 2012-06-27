//
//  PlayerCellView.h
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQGridViewCell.h"
#import "PlayerImageView.h"
#import "GradientButton.h"

@interface PlayerCellView : AQGridViewCell {
    PlayerImageView *_player;
    UIButton *_btnEdit;
    GradientButton *_btnDelete;
    
    BOOL _selected;
}

@property (nonatomic, retain) PlayerImageView * player;
@property (nonatomic, retain) UIButton * btnEdit;
@property (nonatomic, retain) GradientButton * btnDelete;
@property (nonatomic) BOOL selected;

@end
