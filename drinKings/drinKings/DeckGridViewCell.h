//
//  DeckGridViewCell.h
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "AQGridViewCell.h"
#import "GradientButton.h"

@interface DeckGridViewCell : AQGridViewCell {
    UIImageView *_ivDeck;
    UILabel *_lblName;
    GradientButton *_btnDelete;
    
    bool _isSelected;
}

@property (nonatomic, retain) UIImageView *ivDeck;
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic, retain) GradientButton * btnDelete;
@property (nonatomic) bool isSelected;

@end
