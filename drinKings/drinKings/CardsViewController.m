//
//  CardsViewController.m
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "CardsViewController.h"
#import "CardsHelper.h"
#import "Deck.h"
#import "AppDelegate.h"
#import "Card.h"
#import "CardGridViewCell.h"
#import "Rule.h"

@interface CardsViewController ()

@end

@implementation CardsViewController

@synthesize theDeck=_theDeck;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"Cards";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    _chosenItems = [[NSMutableArray alloc] init];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _itemSize = CGSizeMake(150.0*kCardRatio, 150.0);
    }else{
        _itemSize = CGSizeMake(300.0*kCardRatio, 300.0);
    }
    
    _gv = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, w, h-h/8)];
    _gv.scrollsToTop = YES;
    //_gv.backgroundColor = [UIColor darkGrayColor];
    _gv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    _gv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gv.autoresizesSubviews = YES;
    _gv.dataSource = self;
    _gv.delegate = self;
    [self.view addSubview:_gv];
    
    
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateFromDB];
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    float y = h-h/8;
    
    if(_btnSelectAll==nil){
        _btnSelectAll = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnSelectAll useWhiteStyle];
        _btnSelectAll.frame = CGRectMake(w/3-w/3.2, y, w/3.5, h/10);
        [_btnSelectAll setTitle:@"Select All" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_btnSelectAll.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        }else{
            [_btnSelectAll.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        }
        [self.view addSubview:_btnSelectAll];
    }
    
    if(_btnSelectNone==nil){
        _btnSelectNone = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnSelectNone useBlackActionSheetStyle];
        _btnSelectNone.frame = CGRectMake(w-w/3.5-(w/3-w/3.2), y, w/3.5, h/10);
        [_btnSelectNone setTitle:@"Select None" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_btnSelectNone.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        }else{
            [_btnSelectNone.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        }
        [self.view addSubview:_btnSelectNone];
    }
    
    if(_btnRules==nil){
        _btnRules = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnRules useSimpleOrangeStyle];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [_btnRules.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        }else{
            [_btnRules.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        }
        _btnRules.frame = CGRectMake(w/2-(w/3)/2, y, w/3, h/10);
        [_btnRules setTitle:@"Rules" forState:UIControlStateNormal];
        [self.view addSubview:_btnRules];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }
}

- (void)updateFromDB{
    
    NSArray *sortArray = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"suit" ascending:YES], nil];
    
    _arrayItems = (NSMutableArray*)[[_theDeck.cards allObjects] sortedArrayUsingDescriptors:sortArray];
    
    DLog(@"arrayItems %@", _arrayItems);
    
    [_gv reloadData];
}

#pragma mark -
#pragma mark Grid View Data Source

- (void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    
    DLog (@"Selected theArgument=%d\n", index);
    
    Card *aCard = [_arrayItems objectAtIndex:index];
    
    if([_chosenItems containsObject:aCard]){
        DLog(@"remove %@", aCard);
        [_chosenItems removeObject:aCard];
    }else{
        DLog(@"add %@", aCard);
        [_chosenItems addObject:aCard];
    }
    
    [_gv deselectItemAtIndex:index animated:NO];
    [_gv reloadData];
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    DLog(@"~ %i", [_arrayItems count]);
    return [_arrayItems count];
    //return 10;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    DLog(@"~");
    
    NSString *cellIdentifier = @"cell";
    
    CardGridViewCell * cell = (CardGridViewCell *)[_gv dequeueReusableCellWithIdentifier: cellIdentifier];
    if ( cell == nil )
    {
        cell = [[CardGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, _itemSize.width, _itemSize.height)
                                       reuseIdentifier: cellIdentifier];
        //cell.selectionGlowColor = [UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:1.0];
        cell.selectionGlowColor = [UIColor yellowColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Card *aCard = [_arrayItems objectAtIndex:index];
    
    if(aCard.rule==nil){
        cell.lblName.text = @"No Rule";
        cell.lblName.textColor = [UIColor redColor];
    }else{
        cell.lblName.text = aCard.rule.name;
        cell.lblName.textColor = [UIColor whiteColor];
    }
    [cell.ivCard setImage:[CardsHelper imageForCard:aCard]];
    
    if([_chosenItems containsObject:aCard]){
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:1.0]];
    }else{
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    /*cell.player.image.alpha = 1.0;
     
     Player *aPlayer = [_arrayItems objectAtIndex:index-1];
     
     cell.player.name.text = aPlayer.name;
     
     cell.player.image.image = [UIImage imageWithData:aPlayer.photo];
     
     if([_chosenItems containsObject:aPlayer]){
     DLog(@"contains %@", aPlayer);
     //[cell setSelected:YES];
     //cell.selected=YES;
     }else{
     DLog(@"nope %@", aPlayer);
     //[cell setSelected:NO];
     //cell.selected=NO;
     }
     
     if([_chosenItems containsObject:aPlayer]){
     [cell.player setBackgroundColor:[UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:1.0]];
     }else{
     [cell.player setBackgroundColor:[UIColor whiteColor]];
     }
     
     if(_editMode){
     cell.btnDelete.hidden=NO;
     cell.btnDelete.tag = index-1;
     [cell.btnDelete addTarget:self action:@selector(confirmDeleteItem:) forControlEvents:UIControlEventTouchUpInside];
     }else{
     cell.btnDelete.hidden=YES;
     }*/

    
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    DLog(@"~");
    
    /*float w = self.view.frame.size.width;
     float h = self.view.frame.size.height;
     
     CGSize size;
     
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     size = CGSizeMake(120.0, 160.0);
     }else{
     size = CGSizeMake(240.0, 320.0);
     }
     
     DLog(@"%f %f", size.width, size.height);*/
    
    CGSize size = CGSizeMake(_itemSize.width+10, _itemSize.height+15);
    
    return size;
}

@end
