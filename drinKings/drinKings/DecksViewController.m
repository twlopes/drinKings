//
//  DecksViewController.m
//  drinKings
//
//  Created by Tristan Lopes on 27/07/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "DecksViewController.h"
#import "CardsHelper.h"
#import "Deck.h"
#import "AppDelegate.h"
#import "DeckGridViewCell.h"
#import "CardsViewController.h"
#import "RulesHelper.h"

@interface DecksViewController ()

@end

@implementation DecksViewController

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
    
    self.title = @"Decks";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _itemSize = CGSizeMake(170.0*kCardRatio, 170.0);
    }else{
        _itemSize = CGSizeMake(300.0*kCardRatio, 300.0);
    }

    _gv = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    _gv.scrollsToTop = YES;
    //_gv.backgroundColor = [UIColor darkGrayColor];
    //_gv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    _gv.backgroundColor = [UIColor clearColor];
    _gv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gv.autoresizesSubviews = YES;
    _gv.dataSource = self;
    _gv.delegate = self;
    [self.view addSubview:_gv];
}

- (void)viewWillDisappear:(BOOL)animated{
    [hud hide:NO];
    hud.delegate=nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_gv flashScrollIndicators];
    
    [self updateFromDB];
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
    NSManagedObjectContext *moc;
    
    if (moc == nil) {
        DLog(@"nil");
        moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    _arrayItems = (NSMutableArray*)[moc fetchObjectsForEntityName:@"Deck"];
    
    DLog(@"arrayItems %@", _arrayItems);
    
    [_gv reloadData];
}

- (void)addDeck{
    
    if(hud==nil){
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    [self.navigationController.view addSubview:hud];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.userInteractionEnabled=NO;
    
    hud.delegate = (id<MBProgressHUDDelegate>)self;
    hud.labelText = @"Creating";
    
    [hud show:YES];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSManagedObjectContext *moc/* = [ac managedObjectContext]*/;
        
        if (moc == nil) {
            DLog(@"nil");
            moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        }
        
        Deck *deck = (Deck *)[NSEntityDescription insertNewObjectForEntityForName:@"Deck"
                                                           inManagedObjectContext:moc];
        
        deck.name = [NSString stringWithFormat:@"Deck #%i", [_arrayItems count]+1];
        
        for(int suit=0; suit<4; suit++){
            NSMutableString *s = [[NSMutableString alloc] init];
            
            if(suit==0){
                [s appendString:@"Hearts"];
            }
            
            if(suit==1){
                [s appendString:@"Spades"];
            }
            
            if(suit==2){
                [s appendString:@"Diamonds"];
            }
            
            if(suit==3){
                [s appendString:@"Clubs"];
            }
            
            // loop through cards
            for(int i=1; i<=13; i++){
                
                /*NSEntityDescription* entity = [NSEntityDescription entityForName:@"Card"
                 inManagedObjectContext:moc];
                 NSFetchRequest* request = [[NSFetchRequest alloc] init];
                 [request setEntity:entity];
                 
                 [request setPredicate:[NSPredicate predicateWithFormat:@"suit = %@ AND number = %i", s, i]];
                 
                 NSError *error = nil;
                 NSArray *cardArray = [moc executeFetchRequest:request error:&error];
                 
                 if([cardArray count]==0){*/
                DLog(@"creating %i %@", i, s);
                Card *card = (Card *)[NSEntityDescription insertNewObjectForEntityForName:@"Card"
                                                                   inManagedObjectContext:moc];
                
                card.number = [NSNumber numberWithInt:i];
                card.suit = s;
                card.deck = deck;
                
                if(i==1){
                    // ace
                    card.rule = [RulesHelper ruleWithShortName:@"Rule"];
                }
                
                if(i>=2 && i<=4){
                    if([s isEqual:@"Hearts"] || [s isEqual:@"Diamonds"]){
                        card.rule = [RulesHelper ruleWithShortName:[NSString stringWithFormat:@"Give%i", i]];
                    }else{
                        card.rule = [RulesHelper ruleWithShortName:[NSString stringWithFormat:@"Take%i", i]];
                    }
                }
                
                if(i==5){
                    card.rule = [RulesHelper ruleWithShortName:@"Moose"];
                }
                
                if(i==6){
                    card.rule = [RulesHelper ruleWithShortName:@"Nose"];
                }
                
                if(i==7){
                    card.rule = [RulesHelper ruleWithShortName:@"Categories"];
                }
                
                if(i==8){
                    card.rule = [RulesHelper ruleWithShortName:@"Never"];
                }
                
                if(i==9){
                    card.rule = [RulesHelper ruleWithShortName:@"Rhyme"];
                }
                
                if(i==10){
                    card.rule = [RulesHelper ruleWithShortName:@"Floor"];
                }
                
                if(i==11){
                    card.rule = [RulesHelper ruleWithShortName:@"FamousMales"];
                }
                
                if(i==12){
                    card.rule = [RulesHelper ruleWithShortName:@"FamousFemales"];
                }
                
                if(i==13){
                    card.rule = [RulesHelper ruleWithShortName:@"Social"];
                }
                /*}else{
                 DLog(@"exists %i %@", i, s);
                 }*/
                
                NSError *mocerror;
                if (![moc save:&mocerror]) {
                    NSLog(@"Whoops, couldn't save: %@", [mocerror localizedDescription]);
                }
            }
        }
        
        // we will still create the jokers but give them nil on the rule so they can't be played
        Card *card = (Card *)[NSEntityDescription insertNewObjectForEntityForName:@"Card"
                                                           inManagedObjectContext:moc];
        
        card.number = @0;
        card.suit = @"Red";
        card.deck = deck;
        card.rule = nil;
        
        NSError *mocerror;
        if (![moc save:&mocerror]) {
            NSLog(@"Whoops, couldn't save: %@", [mocerror localizedDescription]);
        }
        
        card = (Card *)[NSEntityDescription insertNewObjectForEntityForName:@"Card"
                                                     inManagedObjectContext:moc];
        
        card.number = @0;
        card.suit = @"Black";
        card.deck = deck;
        card.rule = nil;
        
        if (![moc save:&mocerror]) {
            NSLog(@"Whoops, couldn't save: %@", [mocerror localizedDescription]);
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [hud hide:YES afterDelay:0.5];
        
            [self updateFromDB];
        });
        
    });
}

- (void)confirmDeleteItem:(UIButton*)sender{
    DLog(@"~");
    
    Deck *aDeck = [_arrayItems objectAtIndex:sender.tag];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                        message:[NSString stringWithFormat:@"Are you sure you want to delete '%@'?", aDeck.name]
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
    
    Deck *aDeck = [_arrayItems objectAtIndex:tag];
    
    [moc deleteObject:aDeck];
    
    NSError *error;
    if (![moc save:&error]) {
        DLog(@"Error deleting");
    }
    
    [self updateFromDB];
}

#pragma mark -
#pragma mark Grid View Data Source

- (void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    
    DLog (@"Selected theArgument=%d\n", index);
    
    if(index==0){
        // add
        [self addDeck];
    }else{
        Deck *aDeck = [_arrayItems objectAtIndex:index-1];
        
        CardsViewController *cards = [[CardsViewController alloc] init];
        cards.theDeck = aDeck;
        [self.navigationController pushViewController:cards animated:YES];
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
    
    DeckGridViewCell * cell = (DeckGridViewCell *)[_gv dequeueReusableCellWithIdentifier: cellIdentifier];
    if ( cell == nil )
    {
        cell = [[DeckGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, _itemSize.width, _itemSize.height)
                                     reuseIdentifier: cellIdentifier];
        //cell.selectionGlowColor = [UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:1.0];
        //cell.selectionGlowColor = [UIColor yellowColor];
        //cell.selectionGlowColor = [Skins colorWithHexString:@"FFFF00" alpha:0.4];
        //cell.backgroundColor = [UIColor clearColor];
        //cell.selectionGlowColor = [UIColor colorWithRed:81.0/256 green:102.0/265 blue:145.0/256 alpha:0.5];
        cell.selectionStyle = AQGridViewCellSelectionStyleNone;
    }
    
    if(index==0){
        
        cell.lblName.text = @"Create new deck";
        
        /*cell.player.name.text = @"Create New Player";
        [cell.player.btnPlayer addTarget:self action:@selector(addPlayer) forControlEvents:UIControlEventTouchUpInside];
        cell.player.image.image=[UIImage imageNamed:@"defaultUser.png"];
        cell.player.image.alpha = 0.5;
        [cell.player setBackgroundColor:[UIColor whiteColor]];
        cell.btnDelete.hidden=YES;*/
        
        cell.btnDelete.hidden=YES;
    }else{
        
        cell.btnDelete.hidden=NO;
        cell.btnDelete.tag = index-1;
        [cell.btnDelete addTarget:self action:@selector(confirmDeleteItem:) forControlEvents:UIControlEventTouchUpInside];
        
        Deck *aDeck = [_arrayItems objectAtIndex:index-1];
        
        cell.lblName.text = aDeck.name;
        
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
    
    CGSize size = CGSizeMake(_itemSize.width+10, _itemSize.height+15);
    
    return size;
}

@end
