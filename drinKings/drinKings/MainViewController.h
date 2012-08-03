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
    GradientButton *_btnPlay;
    GradientButton *_btnAbout;
    GradientButton *_btnHelp;
    GradientButton *_btnDeck;
    
    UIImageView *_ivBG;
}

@end
