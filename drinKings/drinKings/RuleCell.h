//
//  RuleCell.h
//  drinKings
//
//  Created by Tristan Lopes on 9/08/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuleCell : UITableViewCell {
    UILabel *_label;
    bool _resizeLabel;
    
    UIButton *_btnInfo;
    NSMutableString *_infoString;
}

@property (assign) bool resizeLabel;
@property (nonatomic,retain) UILabel *label;
@property (nonatomic,retain) UIButton *btnInfo;
@property (nonatomic,retain) NSMutableString *infoString;

@end
