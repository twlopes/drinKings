//
//  PlayerImage.h
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerImageView : UIView {
    UIImageView *_image;
    UILabel *_name;
    
    UIButton *_btnPlayer;
}

@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UIButton *btnPlayer;

@end
