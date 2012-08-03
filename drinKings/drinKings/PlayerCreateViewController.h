//
//  PlayerCreateViewController.h
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerChoiceViewController.h"
#import "MBProgressHUD.h"

@class Player;

@interface PlayerCreateViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate> {
    UIScrollView *_sv;
    UIView *_viewBG;
    UIImageView *_ivPlayer;
    UIButton *_btnCamera;
    
    UITextField *_tfName;
    
    UIImage *_image;
    UIImagePickerController *_picker;
    UIPopoverController *_popover;
    
    Player *_player;
    PlayerChoiceViewController *_parent;
    
    bool _changed;
    
    MBProgressHUD* hud;
}

@property (nonatomic,retain) UIPopoverController *popover;
@property (nonatomic,retain) Player *player;
@property (nonatomic,retain) PlayerChoiceViewController *parent;

-(void)registerNotifications;
- (void)refreshImage;

@end
