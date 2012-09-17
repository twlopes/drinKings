//
//  GameBoardViewController.m
//  drinkingcards
//
//  Created by Tristan Lopes on 22/03/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "GameBoardViewController.h"
#import "AppDelegate.h"
#import "GamePlayer.h"
#import "GameCard.h"
#import "Rule.h"
#import "CardsHelper.h"
#import "GamePlayerView.h"
#import "HeldCardsView.h"

#define kGameBoardDivisor 10

@interface GameBoardViewController ()

@end

@implementation GameBoardViewController

@synthesize players=_players, currentCard=_currentCard, currentGameCard=_currentGameCard, currentDeck=_currentDeck;

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
    
    [self newGame];
}

- (void)newGame{
    // setup the game, cards and players
    [self setupGame];
    
    // game board and elements
    [self drawBoard];
    
    // update HUD
    [self updateDisplay];
    
    if([_currentGame.turn isEqualToNumber:[NSNumber numberWithInt:0]]){
        // randomise the cards and give them positions
        [self shuffleCards];
    }
    
    // draw cards on board
    [self dealCards];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }
    }
    
    if(_nextPlayerView==nil){
        float nH = h/1.3;
        float nW = nH*kCardRatio;
        _nextPlayerView = [[PlayerImageView alloc] initWithFrame:CGRectMake(w/2-nW/2, h/2-nH/2, nW, nH)];
        
        _nextPlayerView.alpha=0;
        _nextPlayerView.userInteractionEnabled=NO;
        //_nextPlayerView.hidden=YES;
        [self.view addSubview:_nextPlayerView];
    }
    
    [self displayNextPlayer];
}

#pragma mark - Setup

- (void)setupGame{
    DLog(@"~");
    
    NSManagedObjectContext *moc;
    if (moc == nil) { 
        moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    // see if a game record is there, otherwise create one
    if(_currentGame==nil){
        DLog(@"setting up game");
        
        // Delete all instances of game, gamecard, gameplayer
        NSFetchRequest * allItems = [[NSFetchRequest alloc] init];
        [allItems setEntity:[NSEntityDescription entityForName:@"Game" inManagedObjectContext:moc]];
        [allItems setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray * all = [moc executeFetchRequest:allItems error:&error];

        //error handling goes here
        for (NSManagedObject * item in all) {
            [moc deleteObject:item];
        }
        
        [allItems setEntity:[NSEntityDescription entityForName:@"GameCard" inManagedObjectContext:moc]];
        [allItems setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        error = nil;
        all = [moc executeFetchRequest:allItems error:&error];
        
        //error handling goes here
        for (NSManagedObject * item in all) {
            [moc deleteObject:item];
        }
        
        [allItems setEntity:[NSEntityDescription entityForName:@"GamePlayer" inManagedObjectContext:moc]];
        [allItems setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        error = nil;
        all = [moc executeFetchRequest:allItems error:&error];
        
        //error handling goes here
        for (NSManagedObject * item in all) {
            [moc deleteObject:item];
        }
        
        NSError *saveError = nil;
        [moc save:&saveError];
        
        _currentGame = (Game *)[NSEntityDescription insertNewObjectForEntityForName:@"Game"
                                                          inManagedObjectContext:moc];
        _currentGame.turn=[NSNumber numberWithInt:0];
        DLog(@"new game %@", _currentGame);
        
        // setup the cards for the game
        // for the time being we will be creating a record for all of them
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"Card"
                                                  inManagedObjectContext:moc];
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        [request setPredicate:[NSPredicate predicateWithFormat:@"deck = %@ AND rule != %@", _currentDeck, nil]];
        
        error = nil;
        NSArray *cardArray = [moc executeFetchRequest:request error:&error];
        
        if(cardArray!=nil && [cardArray count]>0){
            // need to create the linking GameCard records
            DLog(@"setting up cards");
            for(int i=0; i<[cardArray count]; i++){
                Card *aCard = [cardArray objectAtIndex:i];
                
                GameCard *aGameCard = (GameCard *)[NSEntityDescription insertNewObjectForEntityForName:@"GameCard" inManagedObjectContext:moc];
                aGameCard.card = aCard;
                aGameCard.game = _currentGame;
                aGameCard.played = [NSNumber numberWithBool:NO];
                aGameCard.holding = [NSNumber numberWithBool:NO];
                
                DLog(@"adding card: %@ %@", aGameCard.card.number, aGameCard.card.suit);
                [_currentGame addCardsObject:aGameCard];
            }
        }else{
            // there is a problem here...
            DLog(@"error, no cards found");
            _currentGame.cards=nil;
            [self endGame];
        }
        
        // setup the players for the game
        if(_players!=nil && [_players count]>0){
            // need to create the linking GamePlayer records
            
            for(int i=0; i<[_players count]; i++){
                Player *aPlayer = [_players objectAtIndex:i];
                
                GamePlayer *aGamePlayer = (GamePlayer *)[NSEntityDescription insertNewObjectForEntityForName:@"GamePlayer" inManagedObjectContext:moc];
                aGamePlayer.player = aPlayer;
                aGamePlayer.game = _currentGame;
                aGamePlayer.playerTurn = [NSNumber numberWithInt:i];
                
                
                DLog(@"adding player: %@ %@", aGamePlayer.player.name, aGamePlayer.playerTurn);
                [_currentGame addPlayersObject:aGamePlayer];
            }
        }else{
            // this is a quick game
            DLog(@"quick game");
            _currentGame.players=nil;
        }
    }
    
    // select the player
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"playerTurn == %i", [_currentGame.turn intValue]];
    NSArray *filteredArray = [[_currentGame.players allObjects] filteredArrayUsingPredicate:predicate];
    if ([filteredArray count] > 0) {
        GamePlayer *gp = (GamePlayer*)[filteredArray objectAtIndex:0];
        _currentPlayer = gp.player;
        _currentGamePlayer = gp;
    }
    
    NSError *mocerror;
    if (![moc save:&mocerror]) {
        NSLog(@"Whoops, couldn't save: %@", [mocerror localizedDescription]);
    }
    
    _turnAllowed=YES;
    _doNextTurn=YES;
    _showingNextPlayer=NO;
    _animatingNextPlayer=NO;
    _showingCard=NO;
    _animatingCard=NO;
}

- (void)drawBoard{
    DLog(@"~");
    
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }
    }
    
    if(_ivBG==nil){
        _ivBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    }
    [_ivBG setImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    _ivBG.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_ivBG];
    
    if(_toolbar==nil){
        _toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h/kGameBoardDivisor)];
    }
    _toolbar.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    /*_toolbar.layer.shadowOffset = CGSizeMake(0, 2);
    _toolbar.layer.shadowOpacity = 0.7;
    _toolbar.layer.shadowRadius = 8;
    _toolbar.layer.shadowColor = [UIColor blackColor].CGColor;
    _toolbar.layer.masksToBounds=NO;*/
    [self.view addSubview:_toolbar];
    
    _arrayPlayerViews = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"playerTurn" ascending:YES];
    NSArray *players = [[_currentGame.players allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    int i=0;
    float gpViewWidth = (w-(h/kGameBoardDivisor))/[players count];
    for(GamePlayer *p in players){
        GamePlayerView *gpView = [[GamePlayerView alloc] initWithFrame:CGRectMake(i*gpViewWidth, 0, gpViewWidth-5, h/kGameBoardDivisor)];
        
        gpView.gamePlayer = p;
        gpView.ivPlayer.image = [UIImage imageWithData:p.player.photo];
        gpView.lblPlayer.text = p.player.name;
        
        gpView.btnPlayer.tag=[p.playerTurn intValue];
        [gpView.btnPlayer addTarget:self action:@selector(touchPlayer:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:gpView];
        
        [_arrayPlayerViews addObject:gpView];
        i++;
    }
    
    if([players count]==0){
        GamePlayerView *gpView = [[GamePlayerView alloc] initWithFrame:CGRectMake(0, 0, w-(h/kGameBoardDivisor), h/kGameBoardDivisor)];
        
        gpView.ivPlayer.backgroundColor = [UIColor grayColor];
        gpView.lblPlayer.text = @"Turn: 1";
        gpView.ivPlayer.image = [UIImage imageNamed:@"defaultUser.png"];
        [gpView.btnPlayer addTarget:self action:@selector(touchPlayer:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:gpView];
        
        [_arrayPlayerViews addObject:gpView];
    }
    
    
    /*if(_ivPlayer==nil){
        _ivPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, h/15-10, h/15-10)];
    }
    //[_ivPlayer setImage:[UIImage imageNamed:@"Felt-Green.jpg"]];
    _ivPlayer.backgroundColor = [UIColor grayColor];
    _ivPlayer.contentMode = UIViewContentModeScaleAspectFill;
    _ivPlayer.layer.masksToBounds=YES;
    [self.view addSubview:_ivPlayer];
    
    if(_lblPlayerTurn==nil){
        _lblPlayerTurn = [[UILabel alloc] init];
    }
    _lblPlayerTurn.frame = CGRectMake(h/15+10, 0, w/2, h/15);
    _lblPlayerTurn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _lblPlayerTurn.text = @"Player Turn";
    _lblPlayerTurn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_lblPlayerTurn];*/
    
    if(_btnQuit==nil){
        _btnQuit = [GradientButton buttonWithType:UIButtonTypeCustom];
    }
    //_btnQuit.buttonColor = [Skins colorWithHexString:@"8c2b2b"]; // 8c2b2b
    //_btnQuit.cornerRadius = 8;
    [_btnQuit useRedDeleteStyle];
    _btnQuit.frame = CGRectMake(w-h/kGameBoardDivisor, 2.5, h/kGameBoardDivisor-2.5, h/kGameBoardDivisor-5);
    //_btnQuit.backgroundColor = [UIColor redColor];
    [_btnQuit setTitle:@"Quit" forState:UIControlStateNormal];
    //_btnQuit.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_btnQuit addTarget:self action:@selector(touchQuit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnQuit];
    
    // rule bg
    if(_bgRule==nil){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _bgRule = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, h, w-15, 230)];
        }else{
            _bgRule = [[UIImageView alloc] initWithFrame:CGRectMake(30, h, w-60, h/2.2)];
        }
    }
    
    DLog(@"paper size: %f %f", _bgRule.frame.size.width, _bgRule.frame.size.height);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [_bgRule setImage:[UIImage imageNamed:@"paper-iphone.png"]];
    }else{
        [_bgRule setImage:[UIImage imageNamed:@"paper-ipad.png"]];
    }
    _bgRule.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_bgRule];
    
    
    // rule title
    if(_lblRuleTitle==nil){
        _lblRuleTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    _lblRuleTitle.textAlignment = UITextAlignmentCenter;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _lblRuleTitle.font = [UIFont fontWithName:@"Marker Felt" size:36.0];
        _lblRuleTitle.frame = CGRectMake(20, 10, _bgRule.frame.size.width-40, 50);
    }else{
        _lblRuleTitle.font = [UIFont fontWithName:@"Marker Felt" size:48.0];
        _lblRuleTitle.frame = CGRectMake(20, 45, _bgRule.frame.size.width-40, 50);
    }

    //_lblRuleTitle.textColor = [UIColor blueColor];
    _lblRuleTitle.textColor = [Skins colorWithHexString:@"0000A0"];
    _lblRuleTitle.numberOfLines=2;
    _lblRuleTitle.backgroundColor = [UIColor clearColor];
    [_bgRule addSubview:_lblRuleTitle];
    
    
    
    // rule desription
    if(_lblRuleDesc==nil){
        _lblRuleDesc = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    _lblRuleDesc.textAlignment = UITextAlignmentCenter;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _lblRuleDesc.font = [UIFont fontWithName:@"Marker Felt" size:16.0];
        _lblRuleDesc.frame = CGRectMake(20, _lblRuleTitle.frame.size.height+15, _bgRule.frame.size.width-40, _bgRule.frame.size.height-60);
    }else{
        _lblRuleDesc.font = [UIFont fontWithName:@"Marker Felt" size:36.0];
        _lblRuleDesc.frame = CGRectMake(20, _lblRuleTitle.frame.size.height+15, _bgRule.frame.size.width-40, _bgRule.frame.size.height-60);
    }
    
    _lblRuleDesc.numberOfLines=0;
    //_lblRuleDesc.textColor = [UIColor blueColor];
    _lblRuleDesc.textColor = [Skins colorWithHexString:@"0000A0"];
    _lblRuleDesc.backgroundColor = [UIColor clearColor];
    [_bgRule addSubview:_lblRuleDesc];
    
    if(_btnFade==nil){
        _btnFade = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _btnFade.frame = CGRectMake(0, 0, w, h);
    _btnFade.hidden=YES;
    _btnFade.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.45f];
    //_btnFade.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_btnFade addTarget:self action:@selector(removeRule) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFade];
    
    if(_btnFadePlayer==nil){
        _btnFadePlayer = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _btnFadePlayer.frame = CGRectMake(0, 0, w, h);
    _btnFadePlayer.hidden=YES;
    _btnFadePlayer.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.45f];
    //_btnFade.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_btnFadePlayer addTarget:self action:@selector(removePlayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFadePlayer];
    
    
    
    /*NSLog(@"Available fonts: %@", [UIFont familyNames]);
    
    NSArray *fontFamilyNames = [UIFont familyNames];
    NSLog( @"familyNames: %d", [fontFamilyNames count] );
    
    for(NSString *familyName in fontFamilyNames) {
        NSLog(@"familyName: %@", familyName );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        NSLog( @"fontNames: %@", fontNames );
    }*/
}

- (void)shuffleCards{
    DLog(@"~");
    
    // get position of cards
    CGSize theSize;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        theSize = self.view.frame.size;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height)
            theSize = CGSizeMake(self.view.frame.size.height, self.view.frame.size.width);
        else
            theSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
    
    theSize.height = theSize.height - theSize.height/kGameBoardDivisor;
    
    [CardsHelper positionCardsForGame:_currentGame withDimensions:theSize];
}

- (void)dealCards{
    DLog(@"~");
    
    CGSize theSize;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        theSize = self.view.frame.size;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height)
            theSize = CGSizeMake(self.view.frame.size.height, self.view.frame.size.width);
        else
            theSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
    
    //theSize.height = theSize.height - theSize.height/7;
    
    NSArray *gameCardArray = [_currentGame.cards allObjects];
    for(int i=0; i<[gameCardArray count]; i++){
        GameCard *gc = [gameCardArray objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[btn setImage:[CardsHelper imageForCard:gc.card] forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [btn setImage:[UIImage imageNamed:@"back-iphone.png"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"back-ipad.png"] forState:UIControlStateNormal];
        }
        
        // linking the two
        gc.tag=[NSNumber numberWithInt:i];
        btn.tag=i;

        //btn.layer.shadowOpacity = 0.5;
        
        // Add Shine
        /*CAGradientLayer *shineLayer = [CAGradientLayer layer];
        shineLayer.frame = layer.bounds;
        shineLayer.colors = [NSArray arrayWithObjects:
                             (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                             (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                             (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                             (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                             (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                             nil];
        shineLayer.locations = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:0.5f],
                                [NSNumber numberWithFloat:0.5f],
                                [NSNumber numberWithFloat:0.8f],
                                [NSNumber numberWithFloat:1.0f],
                                nil];
        [layer addSublayer:shineLayer];*/
        
        
        CGSize size = [CardsHelper sizeOfCard:theSize];
        btn.frame = CGRectMake([gc.positionX floatValue], [gc.positionY floatValue], size.width, size.height);
        CGAffineTransform transform = CGAffineTransformMakeRotation([gc.rotation floatValue]);
        btn.transform = transform;
        
        /*btn.layer.shadowColor = [UIColor blackColor].CGColor;
        btn.layer.shadowOpacity = 0.3;
        btn.layer.shadowRadius = 2;
        btn.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
        btn.layer.shouldRasterize=YES;*/
        
        /*CAGradientLayer *darkLayer = [CAGradientLayer layer];
        darkLayer.frame = btn.layer.bounds;
        darkLayer.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, nil];
        [btn.layer addSublayer:darkLayer];
        
        darkLayer.frame = self.view.bounds;
        [self.view.layer addSublayer:darkLayer];*/
        
        //CALayer *layer = btn.layer;
        //btn.layer.cornerRadius = 8.0f;
        //btn.layer.masksToBounds = YES;
        //btn.layer.borderWidth = 5.0f;
        //btn.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
        //btn.layer.shouldRasterize = YES;
        [btn addTarget:self action:@selector(selectCard:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    [_currentGame.managedObjectContext save:nil];
}

#pragma mark - Held Cards

- (void)heldCardsClose:(HeldCardsView*)hcv{
    [hcv removeFromSuperview];
}

- (void)heldCardsPlay:(HeldCardsView*)hcv{
    [self heldCardsClose:hcv];
    
    _turnAllowed=NO;
    _doNextTurn=NO; // we dont want this to change players
    
    [self displayCard:nil];
    
    
    // display rule
    [self performSelector:@selector(displayRule) withObject:nil afterDelay:0.6f];
}

#pragma mark - Buttons

- (void)touchDrawCard{
    DLog(@"~");
    
    //[self selectCard];
}

- (void)touchPlayer:(UIButton*)btn{
    DLog(@"~");
    
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }
    }
    
    // get game player
    GamePlayer *gp=nil;
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"playerTurn" ascending:YES];
    NSArray *players = [[_currentGame.players allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    int i=0;
    for(GamePlayer *p in players){
        
        if([p.playerTurn intValue]==btn.tag){
            gp = p;
            break;
        }
        i++;
    }
    
    
    //UIButton *btn = (UIButton*)sender;
    HeldCardsView *hcv = [[HeldCardsView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    hcv.delegate=self;
    
    if(gp==nil){
        [hcv setGame:_currentGame];
    }else{
        [hcv setGamePlayer:gp];
    }
    //hcv.userInteractionEnabled=NO;
    [self.view addSubview:hcv];
    [self.view bringSubviewToFront:hcv];
}

- (void)selectCard:(UIButton*)sender{
    DLog(@"~");
    
    if(!_turnAllowed){
        DLog(@"turn blocked");
        return;
    }else{
        DLog(@"turn allowed");
        _turnAllowed=NO;
    }
    
    [self.view bringSubviewToFront:sender];
    
    // get the card associated with this tag
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag == %i", sender.tag];
    NSArray *filteredArray = [[_currentGame.cards allObjects] filteredArrayUsingPredicate:predicate];
    if([filteredArray count]>0){
        
        
        GameCard *gc = [filteredArray objectAtIndex:0];
        _currentCard = gc.card;
        _currentGameCard = gc;
        
        if([gc.card.rule.holdable isEqualToNumber:[NSNumber numberWithBool:YES]]){
            gc.holding=[NSNumber numberWithBool:YES];
        }else{
            gc.played=[NSNumber numberWithBool:YES];
        }
        gc.player = _currentGamePlayer;
        [gc.managedObjectContext save:nil];
        
        // display card
        [self displayCard:sender];
        
        
        
        // display rule
        [self performSelector:@selector(displayRule) withObject:nil afterDelay:0.6f];
        //[self displayRule];
    }
    
    // pick a random number with the number of cards left (this will be void once graphics are in)
    /*NSPredicate *predicate = [NSPredicate predicateWithFormat:@"played == %@", [NSNumber numberWithBool:NO]];
    NSArray *filteredArray = [[_currentGame.cards allObjects] filteredArrayUsingPredicate:predicate];
    int random=0;
    if([filteredArray count]>0){
        DLog(@"remaining cards: %i", [filteredArray count]);
        random = arc4random() % [filteredArray count];

        GameCard *gc = [filteredArray objectAtIndex:random];
        _currentCard = gc.card;
        
        gc.played=[NSNumber numberWithBool:YES];
        [gc.managedObjectContext save:nil];
        
        _lblCardsRemaining.text = [NSString stringWithFormat:@"%i remaining", [filteredArray count]-1];
        
        // display card
        [self displayCard];
        
        // display rule
        [self displayRule];
    }else{
        [self endGame];
    }*/
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    // rule dismissed
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }
    }
    
    if(alertView.tag==10){
        if(_ivCurrentCard!=nil){
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void) {
                                 DLog(@"animate remove card");
                                 
                                 CGRect frame = _ivCurrentCard.frame;
                                 frame.origin.y = h;
                                 _ivCurrentCard.frame = frame;
                             }
                             completion:^(BOOL finished) {
                                 DLog(@"all done");
                                 [_ivCurrentCard removeFromSuperview];
                             }];
        }
        
        [self nextTurn];
    }
    
    if(alertView.tag==1){
        if(buttonIndex==alertView.cancelButtonIndex){
            [self quit];
        }
    }
    
    if(alertView.tag==20){
        if(buttonIndex==alertView.cancelButtonIndex){
            [self quit];
        }else{
            _currentGame=nil;
            _currentCard=nil;
            _currentGameCard=nil;
            _currentGamePlayer=nil;
            _currentPlayer=nil;
            [self newGame];
            
            [self displayNextPlayer];
        }
    }
}

- (void)touchQuit{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to Quit?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Quit"
                                              otherButtonTitles:@"No", nil];
    alertView.tag=1;
    
    [alertView show];
}

#pragma mark - Actions

- (void)displayCard:(UIButton*)sender{
    DLog(@"~");
    
    if(_animatingCard || _showingCard){
        return;
    }
    
    _animatingCard=YES;
    
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }
    }
    
    if(_ivCurrentCard==nil){
        _ivCurrentCard = [[UIImageView alloc] init];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    
        _ivCurrentCard.frame = CGRectMake((w/2) - (w/(1.2*2)), h, w/1.2, (w/1.2) / kCardRatio);
        
    }else{
        _ivCurrentCard.frame = CGRectMake((w/2) - (w/(1.5*2)), h, w/1.5, (w/1.5) / kCardRatio);
    }
    DLog(@"current card %f %f %f %f", _ivCurrentCard.frame.origin.x, _ivCurrentCard.frame.origin.y, _ivCurrentCard.frame.size.width, _ivCurrentCard.frame.size.height);
    _ivCurrentCard.image = [CardsHelper imageForCard:_currentCard];
    _ivCurrentCard.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_ivCurrentCard];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         DLog(@"animate take away card");
                         CGAffineTransform transform = CGAffineTransformMakeRotation(0);
                         sender.transform = transform;
                         
                         CGRect frame = sender.frame;
                         frame.origin.x = w/2 - sender.frame.size.width/2;
                         frame.origin.y = h+sender.frame.size.height;
                         sender.frame = frame;
                         
                     }
                     completion:^(BOOL finished) {
                         DLog(@"complete");
                         
                         [sender removeFromSuperview];
                         
                         
                     }];
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         DLog(@"animate bring in card");
                         
                         CGRect frame = _ivCurrentCard.frame;
                         frame.origin.y = h/10;
                         _ivCurrentCard.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         DLog(@"all done");
                     }];
    
}

- (void)displayRule{
    DLog(@"~");
    
    [self.view bringSubviewToFront:_btnFade];
    [self.view bringSubviewToFront:_bgRule];
    
    _lblRuleTitle.text = _currentCard.rule.name;
    _lblRuleDesc.text = _currentCard.rule.desc;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if([_lblRuleDesc.text length]<=100){
            _lblRuleDesc.font = [UIFont fontWithName:@"Marker Felt" size:26.0];
        }else if([_lblRuleDesc.text length]<=200){
            _lblRuleDesc.font = [UIFont fontWithName:@"Marker Felt" size:20.0];
        }else{
            _lblRuleDesc.font = [UIFont fontWithName:@"Marker Felt" size:16.0];
        }
    }

    
    CGSize constraint = CGSizeMake(_lblRuleTitle.frame.size.width, 5000);
    CGSize size = [_lblRuleTitle.text sizeWithFont:_lblRuleTitle.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect frame = _lblRuleTitle.frame;
    frame.size.height = size.height;
    _lblRuleTitle.frame = frame;
    
    frame = _lblRuleDesc.frame;
    frame.origin.y = _lblRuleTitle.frame.origin.y+_lblRuleTitle.frame.size.height;
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        frame.size.height = self.view.frame.size.height-frame.origin.y;
    }else{
        frame.size.height = self.view.frame.size.width-frame.origin.y;
    }*/
    frame.size.height = _bgRule.frame.size.height-frame.origin.y;
    _lblRuleDesc.frame = frame;
    
    _btnFade.alpha=0;
    _btnFade.hidden=NO;
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         DLog(@"animate bring in rule");
                         
                         CGRect frame = _bgRule.frame;
                         frame.origin.y = frame.origin.y-frame.size.height;
                         _bgRule.frame = frame;
                         _btnFade.alpha=1;
                     }
                     completion:^(BOOL finished) {
                         DLog(@"all done");
                         _btnFade.hidden=NO;
                         _showingCard=YES;
                         _animatingCard=NO;
                     }];
    
    /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_currentCard.rule.name
                                                        message:_currentCard.rule.desc
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
    
    alertView.tag=10;
    [alertView show];*/
    
    
    
    //[self nextTurn];
}

- (void)removeRule{
    DLog(@"~");
    
    if(_animatingCard || !_showingCard){
        return;
    }
    
    /*if(!_fadeAllowed){
        return;
    }else{
        _fadeAllowed=NO;
    }*/
    
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }
    }
    
    if(_ivCurrentCard!=nil){
        _animatingCard=YES;
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             DLog(@"animate remove card");
                             
                             CGRect frame = _ivCurrentCard.frame;
                             
                             if([_currentGameCard.holding isEqualToNumber:[NSNumber numberWithBool:YES]] && [_currentGameCard.played isEqualToNumber:[NSNumber numberWithBool:NO]]){
                                 
                                 if(_currentGamePlayer!=nil){
                                     float gpViewWidth = (w-(h/kGameBoardDivisor))/[_currentGame.players count];
                                     
                                     frame.origin.y = h/kGameBoardDivisor/2;
                                     frame.origin.x = (gpViewWidth*(float)[_currentGamePlayer.playerTurn intValue])+h/kGameBoardDivisor/1.5;
                                 }else{
                                     frame.origin.y = h/kGameBoardDivisor/2;
                                     frame.origin.x = h/kGameBoardDivisor/1.5;
                                 }
                                 frame.size.height = 0;
                                 frame.size.width = 0;
                                 
                             }else{
                                 frame.origin.y = h;
                             }
                             _ivCurrentCard.frame = frame;
                             
                             frame = _bgRule.frame;
                             frame.origin.y = h;
                             _bgRule.frame = frame;
                             
                             if([_currentGame.players count]==0){
                                 _btnFade.alpha=0;
                             }
                         }
                         completion:^(BOOL finished) {
                             DLog(@"all done");
                             [_ivCurrentCard removeFromSuperview];
                             _btnFade.hidden=YES;
                             _btnFade.alpha=1;
                             _showingCard=NO;
                             _animatingCard=NO;
                             [self nextTurn];
                             if(!_doNextTurn){
                                 _doNextTurn=YES; // allow turns to start happening again
                                 _turnAllowed=YES;
                             }
                         }];
    }else{
        _showingCard=NO;
        _animatingCard=NO;
    }
}

- (void)displayNextPlayer{
    DLog(@"~");
    
    if(_showingNextPlayer || _animatingNextPlayer){
        DLog(@"%i %i", _showingNextPlayer, _animatingNextPlayer);
        return;
    }else{
        DLog(@"allow next player");
    }
    
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }
    }
    
    if([_currentGame.players count]>0){
    
        _animatingNextPlayer=YES;
        _btnFade.hidden=YES;
        
        [self.view bringSubviewToFront:_btnFadePlayer];
        [self.view bringSubviewToFront:_nextPlayerView];
        
        _btnFadePlayer.hidden=NO;
        
        [_nextPlayerView.image setImage:[UIImage imageWithData:_currentGamePlayer.player.photo]];
        _nextPlayerView.name.text = _currentGamePlayer.player.name;
        //_nextPlayerView.btnPlayer.hidden=NO;
        //_nextPlayerView.transform=CGAffineTransformMakeRotation(10000.0f);
        
        CGRect frame = _nextPlayerView.frame;
        frame.origin.y = -frame.size.height;
        
        _nextPlayerView.frame = frame;
        _nextPlayerView.alpha=0;
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             DLog(@"animate bring in rule");
                             
                             CGRect frame = _nextPlayerView.frame;
                             frame.origin.y = h/2 - frame.size.height/2;
                             
                             _nextPlayerView.frame = frame;
                             _nextPlayerView.alpha=1;
                             //_nextPlayerView.transform = CGAffineTransformMakeRotation(0);
                         }
                         completion:^(BOOL finished) {
                             DLog(@"all done");
                             _fadePlayerAllowed=YES;
                             _showingNextPlayer=YES;
                             _animatingNextPlayer=NO;
                         }];
    }else{
        _turnAllowed=YES;
    }
}

- (void)removePlayer{
    DLog(@"~");
    
    if(!_showingNextPlayer || _animatingNextPlayer){
        DLog(@"%i %i", _showingNextPlayer, _animatingNextPlayer);
        return;
    }else{
        DLog(@"allow player removal");
        _animatingNextPlayer=YES;
    }
    
    float w;
    float h;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        w = self.view.frame.size.width;
        h = self.view.frame.size.height;
    }else{
        if (self.view.frame.size.width < self.view.frame.size.height){
            w = self.view.frame.size.height;
            h = self.view.frame.size.width;
        }else{
            w = self.view.frame.size.width;
            h = self.view.frame.size.height;
        }
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         DLog(@"animate bring in rule");
                         
                         CGRect frame = _nextPlayerView.frame;
                         frame.origin.y = -frame.size.height-10;
                         _nextPlayerView.frame = frame;
                         _btnFadePlayer.alpha=0;
                         _nextPlayerView.alpha=0;
                     }
                     completion:^(BOOL finished) {
                         DLog(@"all done");
                         _btnFadePlayer.hidden=YES;
                         _btnFadePlayer.alpha=1;
                         _nextPlayerView.alpha=1;
                         _showingNextPlayer=NO;
                         _animatingNextPlayer=NO;
                         _turnAllowed=YES;
                     }];
}

- (void)updateDisplay{
    if([_currentGame.players count]>0){
        
        int i=0;
        for(GamePlayerView *p in _arrayPlayerViews){
            int pos = ([_currentGame.turn intValue])%[_currentGame.players count];
            
            if(pos==i){
                p.backgroundView.backgroundColor = [UIColor orangeColor];
                p.lblPlayer.textColor = [UIColor blackColor];
            }else{
                p.backgroundView.backgroundColor = [UIColor clearColor];
                p.lblPlayer.textColor = [UIColor whiteColor];
            }
            
            NSPredicate *predicateHeldCards = [NSPredicate predicateWithFormat:@"holding = %@ AND played = %@", [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO]];
            NSArray *cards = [[p.gamePlayer.cards allObjects] filteredArrayUsingPredicate:predicateHeldCards];
            
            if([cards count]>0){
                [p hasCards:YES];
            }else{
                [p hasCards:NO];
            }
               
            i++;
        }
        
        //_lblPlayerTurn.text = [NSString stringWithFormat:@"Player: %@", _currentPlayer.name];
        //_ivPlayer.image = [UIImage imageWithData:_currentPlayer.photo];
    }else{
        int i=0;
        for(GamePlayerView *p in _arrayPlayerViews){
            p.backgroundView.backgroundColor = [UIColor orangeColor];
            p.lblPlayer.text = [NSString stringWithFormat:@"Turn: %i", [_currentGame.turn intValue]+1];  
            
            NSPredicate *predicateHeldCards = [NSPredicate predicateWithFormat:@"holding = %@ AND played = %@", [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO]];
            NSArray *cards = [[_currentGame.cards allObjects] filteredArrayUsingPredicate:predicateHeldCards];
            
            if([cards count]>0){
                [p hasCards:YES];
            }else{
                [p hasCards:NO];
            }
            
            i++;
        }
    }
}

- (void)nextTurn{
    DLog(@"~");
    
    if(!_doNextTurn){
        [self displayNextPlayer];
        [self updateDisplay];
        
        return;
    }
    
    // check to see there are cards left
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"played == %@ AND holding == %@", [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO]];
    NSArray *filteredArray = [[_currentGame.cards allObjects] filteredArrayUsingPredicate:predicate];
    if([filteredArray count]>0){
    
        // add 1 to turn
        _currentGame.turn = [NSNumber numberWithInt:[_currentGame.turn intValue]+1];
        
        DLog(@"turn: %@", _currentGame.turn);
        
        // find out next player
        if([_currentGame.players count]>0){
            DLog(@"player game");
            int pos = ([_currentGame.turn intValue])%[_currentGame.players count];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"playerTurn == %i", pos];
            NSArray *filteredArray = [[_currentGame.players allObjects] filteredArrayUsingPredicate:predicate];
            if ([filteredArray count] > 0) {
                GamePlayer *gp = (GamePlayer*)[filteredArray objectAtIndex:0];
                _currentPlayer = gp.player;
                _currentGamePlayer = gp;
            }
        }
        
        [self updateDisplay];
        
        NSError *mocerror;
        if (![_currentGame.managedObjectContext save:&mocerror]) {
            NSLog(@"Whoops, couldn't save: %@", [mocerror localizedDescription]);
        }
        
        [self displayNextPlayer];
    }else{
        [self endGame];
    }
}

- (void)endGame{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Quit"
                                              otherButtonTitles:@"Play Again", nil];
    alertView.tag=20;
    [alertView show];
}



- (void)quit{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissModalViewControllerAnimated:YES];
}

@end
