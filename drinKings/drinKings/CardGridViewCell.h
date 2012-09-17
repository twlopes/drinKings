//
//  CardGridViewCell.h
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "AQGridViewCell.h"

@interface CardGridViewCell : AQGridViewCell {
    UIView *_viewSelect;
    UIImageView *_ivCard;
    UILabel *_lblRule;
    
    bool _isSelected;
}

@property (nonatomic, retain) UIView *viewSelect;
@property (nonatomic, retain) UIImageView *ivCard;
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic) bool isSelected;

@end
