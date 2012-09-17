//
//  RuleCell.m
//  drinKings
//
//  Created by Tristan Lopes on 9/08/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "RuleCell.h"

@implementation RuleCell

@synthesize label=_label, btnInfo=_btnInfo, infoString=_infoString, resizeLabel=_resizeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _label = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, self.contentView.frame.size.width, 35)];
        _label.numberOfLines = 1;
        _label.lineBreakMode = UILineBreakModeCharacterWrap;
        _label.font = [UIFont boldSystemFontOfSize:18];
        _label.textAlignment = UITextAlignmentLeft;
        _label.textColor = [UIColor blackColor];
        _label.backgroundColor = [UIColor clearColor];
        //_label.shadowColor = [UIColor colorWithWhite:0 alpha:0.7];
        //_label.shadowOffset = CGSizeMake(0, -1);
        //_label.tag=10;
        [self.contentView addSubview:_label];
        
        float h = self.contentView.frame.size.height;
        
        _btnInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnInfo.frame = CGRectMake(2, h/2-15, 30, 30);
        [_btnInfo setBackgroundImage:[UIImage imageNamed:@"btnSmallNeutralBG.png"] forState:UIControlStateNormal];
        [_btnInfo setImage:[UIImage imageNamed:@"iconInfo.png"] forState:UIControlStateNormal];
        [_btnInfo addTarget:self action:@selector(touchInfo:) forControlEvents:UIControlEventTouchUpInside];
        _btnInfo.hidden=YES;
        [self.contentView addSubview:_btnInfo];

        _resizeLabel=YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //self.textLabel.text = _label.text;
    //self.textLabel.hidden = YES;
    //_label.frame = self.textLabel.frame;
    //_label.font = self.textLabel.font;
    
    if(_resizeLabel){
        [_label sizeToFit];
    }
    CGRect frame = _label.frame;
    if(_resizeLabel){
        frame.size.height = self.frame.size.height;
    }
    if(_infoString !=nil && ![_infoString isEqual:@""]){
        if(_btnInfo.hidden){
            // was previously hidden so we move over the textfield
            frame.origin.x+=26;
            frame.size.width-=26;
        }
        
        _btnInfo.hidden=NO;
    }else{
        if(!_btnInfo.hidden){
            // was previously hidden so we move over the textfield
            frame.origin.x-=35;
            frame.size.width+=35;
        }
        
        _btnInfo.hidden=YES;
    }
    
    _label.frame=frame;
    
    [self.contentView bringSubviewToFront:self.detailTextLabel];
}

- (void)touchInfo:(id)sender{
    if(_infoString!=nil && ![_infoString isEqual:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil
                                                        message: _infoString
                                                       delegate: nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        alert.delegate=self;
        [alert show];
    }
}


@end
