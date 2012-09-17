//
//  DecksViewController.h
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"
#import "MBProgressHUD.h"

@interface DecksViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    
    // Data
    NSMutableArray *_arrayItems;
    
    // Interface
    AQGridView *_gv;
    CGSize _itemSize;
    
    MBProgressHUD* hud;
}

@end
