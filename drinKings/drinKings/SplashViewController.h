//
//  SplashViewController.h
//  drinKings
//
//  Created by Tristan Lopes on 26/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController {
    UIButton *_btnSplashGame;
    UIButton *_btnSplashCompany;
    
    NSTimer *_timerGame;
    NSTimer *_timerCompany;
}

@end
