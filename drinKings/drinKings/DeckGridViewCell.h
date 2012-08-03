//
//  DeckGridViewCell.h
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "AQGridViewCell.h"

@interface DeckGridViewCell : AQGridViewCell {
    UIImageView *_ivDeck;
    UILabel *_lblName;
    
    bool _isSelected;
}

@property (nonatomic, retain) UIImageView *ivDeck;
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic) bool isSelected;

@end
