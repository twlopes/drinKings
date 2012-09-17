//
//  twlViewController.h
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"

@interface MainViewController : UIViewController {
    UIButton *_btnPlay;
    GradientButton *_btnAbout;
    GradientButton *_btnHelp;
    UIButton *_btnDeck;
    
    UIImageView *_ivBG;
    UIImageView *_ivLogo;
    
    UIPopoverController *_popover;
    
    UIView *_viewCover;
    bool _firstLoad;
}

@end
