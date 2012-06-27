//
//  PlayerChoiceViewController.m
//  drinkingcards
//
//  Created by Tristan Lopes on 11/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "PlayerChoiceViewController.h"
#import "Player.h"
#import "AppDelegate.h"
#import "PlayerCellView.h"
#import "PlayerImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "PlayerCreateViewController.h"
#import "MBProgressHUD.h"
#import "GameBoardViewController.h"
#import "CardsHelper.h"

@implementation PlayerChoiceViewController

@synthesize chosenItems=_chosenItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    DLog(@"~");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    DLog(@"~");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)refreshItems{
    NSManagedObjectContext *moc;
    
    if (moc == nil) { 
        DLog(@"nil");
        moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    _arrayItems = (NSMutableArray*)[moc fetchObjectsForEntityName:@"Player"];
    
    DLog(@"arrayItems %@", _arrayItems);
    
    [_gv reloadData];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    DLog(@"~");
    
    [super viewDidLoad];
    
    //_arrayItems = [[NSMutableArray alloc] init];
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    //AppDelegate *ad = [AppDelegate sharedAppController];
    
    //NSManagedObjectContext *moc = [ad managedObjectContext];
    
    _chosenItems = [[NSMutableArray alloc] init];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _playerSize = CGSizeMake(150.0*kCardRatio, 150.0);
    }else{
        _playerSize = CGSizeMake(300.0*kCardRatio, 300.0);
    }
    
    _btnPlay = [GradientButton buttonWithType:UIButtonTypeCustom];
    [_btnPlay useSimpleOrangeStyle];
    [_btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    _btnPlay.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _btnPlay.frame = CGRectMake(20, h-(h/6), w-40, h/7);
    
    _btnPlay.titleLabel.textColor = [UIColor blackColor];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _btnPlay.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    }else{
        _btnPlay.titleLabel.font = [UIFont boldSystemFontOfSize:42.0f];
    }
    
    [_btnPlay addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPlay];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    
    _gv = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, w, _btnPlay.frame.origin.y-5)];
    _gv.scrollsToTop = YES;
    //_gv.backgroundColor = [UIColor darkGrayColor];
    _gv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    _gv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gv.autoresizesSubviews = YES;
    _gv.dataSource = self;
    _gv.delegate = self;
    [self.view addSubview:_gv];
    
    
    
    _editMode = NO;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enableEdit)];
    [self.navigationItem setRightBarButtonItem:edit];
    
    [self playButtonTitle];
    
    self.title = @"Select Players";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshItems];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

#pragma mark -
#pragma mark Buttons

- (void)play{
    GameBoardViewController *board = [[GameBoardViewController alloc] init];
    
    board.players = _chosenItems;
    board.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //[self.navigationController pushViewController:board animated:YES];
    [self.navigationController presentModalViewController:board animated:YES];
}

- (void)addPlayer{
    PlayerCreateViewController *pcvc = [[PlayerCreateViewController alloc] init];
    
    pcvc.parent = self;
    
    [self.navigationController pushViewController:pcvc animated:YES];
}

- (void)enableEdit{
    _editMode=YES;
    
    //[self.navigationItem setRightBarButtonItem:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(disableEdit)];
    [self.navigationItem setRightBarButtonItem:done animated:YES];
    
    [_gv reloadData];
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    // set views with new info
    _gv.frame = CGRectMake(0, 0, w, h);
    
    // commit animations
    [UIView commitAnimations];
}

- (void)disableEdit{
    _editMode=NO;
    
    //[self.navigationItem setRightBarButtonItem:nil];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enableEdit)];
    [self.navigationItem setRightBarButtonItem:save animated:YES];
    
    [_gv reloadData];
    
    float w = self.view.frame.size.width;
    //float h = self.view.frame.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    // set views with new info
    _gv.frame = CGRectMake(0, 0, w, _btnPlay.frame.origin.y-5);
    
    // commit animations
    [UIView commitAnimations];
}

- (void)confirmDeleteItem:(UIButton*)sender{
    DLog(@"~");
    
    Player *aPlayer = [_arrayItems objectAtIndex:sender.tag];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                        message:[NSString stringWithFormat:@"Are you sure you want to delete '%@'?", aPlayer.name]
                                                       delegate:self
                                              cancelButtonTitle:@"Delete"
                                              otherButtonTitles:@"No", nil];
    
    alertView.tag = sender.tag;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==alertView.cancelButtonIndex){
        [self deleteItem:alertView.tag];
    }
}

- (void)deleteItem:(int)tag{
    NSManagedObjectContext *moc/* = [ac managedObjectContext]*/;
    
    if (moc == nil) { 
        DLog(@"nil");
        moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    
    Player *aPlayer = [_arrayItems objectAtIndex:tag];
    
    [moc deleteObject:aPlayer];
    
    NSError *error;
    if (![moc save:&error]) {
        DLog(@"Error deleting");
    }else{
        MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        
        // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
        // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
        //hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconWobble.png"]] autorelease];
        
        // Set custom view mode
        hud.mode = MBProgressHUDModeDeterminate;
        hud.animationType = MBProgressHUDAnimationZoom;
        
        hud.delegate = (id<MBProgressHUDDelegate>)self;
        hud.labelText = @"Deleted";
        hud.userInteractionEnabled=NO;
        
        [hud show:YES];
        [hud hide:YES afterDelay:2];
    }
    
    [self refreshItems];
}

- (void)playButtonTitle{
    if([_chosenItems count]==0){
        [_btnPlay setTitle:@"Quick Play!" forState:UIControlStateNormal];
    }else{
        NSMutableString *playerNames=[[NSMutableString alloc] init];
        
        for(int i=0; i<[_chosenItems count]; i++){
            Player *aPlayer = [_chosenItems objectAtIndex:i];
            
            if(i!=0){
                [playerNames appendFormat:@", %@", aPlayer.name];
            }else{
                [playerNames appendFormat:@"%@", aPlayer.name];
            }
        }
        
        [_btnPlay setTitle:[NSString stringWithFormat:@"Play with %i players", [_chosenItems count]] forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark Grid View Data Source

- (void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    
    DLog (@"Selected theArgument=%d\n", index);
    
    if(_editMode && index!=0){
        PlayerCreateViewController *pcvc = [[PlayerCreateViewController alloc] init];
        
        Player *aPlayer = [_arrayItems objectAtIndex:index-1];
        
        pcvc.player = aPlayer;
        
        [self.navigationController pushViewController:pcvc animated:YES];
    }else if(index==0){
        PlayerCreateViewController *pcvc = [[PlayerCreateViewController alloc] init];
        
        [self.navigationController pushViewController:pcvc animated:YES];
    }else{
        Player *aPlayer = [_arrayItems objectAtIndex:index-1];
        
        if([_chosenItems containsObject:aPlayer]){
            DLog(@"remove %@", aPlayer);
            [_chosenItems removeObject:aPlayer];
        }else{
            DLog(@"add %@", aPlayer);
            [_chosenItems addObject:aPlayer];
        }
        
        [self playButtonTitle];
        
        DLog(@"chosen %@", _chosenItems);
        
        //[_gv reloadData];
    }
    
    [_gv deselectItemAtIndex:index animated:NO];
    [_gv reloadData];
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    DLog(@"~ %i", MAX(1, [_arrayItems count]+1));
    return MAX(1, [_arrayItems count]+1);
    //return 10;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    DLog(@"~");
    
    NSString *cellIdentifier = @"cell";
    
    PlayerCellView * cell = (PlayerCellView *)[_gv dequeueReusableCellWithIdentifier: cellIdentifier];
    if ( cell == nil )
    {
        cell = [[PlayerCellView alloc] initWithFrame: CGRectMake(0.0, 0.0, _playerSize.width, _playerSize.height)
                                                 reuseIdentifier: cellIdentifier];
        cell.selectionGlowColor = [UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:1.0];
    }
    
    if(index==0){
        cell.player.name.text = @"Create New Player";
        [cell.player.btnPlayer addTarget:self action:@selector(addPlayer) forControlEvents:UIControlEventTouchUpInside];
        cell.player.image.image=nil;
        [cell.player setBackgroundColor:[UIColor whiteColor]];
        cell.btnDelete.hidden=YES;
    }else{
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
        }
    }
    
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
    
    CGSize size = CGSizeMake(_playerSize.width+10, _playerSize.height+15);
    
    return size;
}

@end
