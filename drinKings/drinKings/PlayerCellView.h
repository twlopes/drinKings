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

@interface PlayerCellView : AQGridViewCell {
    PlayerImageView *_player;
    UIButton *_btnEdit;
    UIButton *_btnDelete;
    
    BOOL _selected;
}

@property (nonatomic, retain) PlayerImageView * player;
@property (nonatomic, retain) UIButton * btnEdit;
@property (nonatomic, retain) UIButton * btnDelete;
@property (nonatomic) BOOL selected;

@end
