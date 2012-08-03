//
//  HeldCardsView.m
//  drinKings
//
//  Created by Tristan Lopes on 30/06/12.
//  Copyright (c) 2012 Output DSJ. All rights reserved.
//

#import "HeldCardsView.h"
#import "CardsHelper.h"
#import "HeldCardView.h"
#import "GameBoardViewController.h"

@implementation HeldCardsView

@synthesize delegate=_delegate, gamePlayer=_gamePlayer, game=_game;

- (id)initWithFrame:(CGRect)frame
{
    DLog(@"~");
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        float dw;
        float dh;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            dw = [UIScreen mainScreen].bounds.size.width;
            dh = [UIScreen mainScreen].bounds.size.height;
        }else{
            if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height){
                dw = [UIScreen mainScreen].bounds.size.height;
                dh = [UIScreen mainScreen].bounds.size.width;
            }else{
                dw = [UIScreen mainScreen].bounds.size.width;
                dh = [UIScreen mainScreen].bounds.size.height;
            }
        }
        
        _backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
        _backgroundView.frame = CGRectMake(0, 0, dw, dh);
        [_backgroundView addTarget:self action:@selector(touchClose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundView];
        
        float w = _backgroundView.frame.size.width;
        float h = _backgroundView.frame.size.height;
        
        // work out card background height/width
        float bgCardHeight = h - 60; // 20 padding
        float bgCardWidth = bgCardHeight * kCardRatio;
        
        _cardBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(w/2 - bgCardWidth/2, 20, bgCardWidth, bgCardHeight)];
        _cardBackgroundView.backgroundColor = [UIColor whiteColor];
        //_cardBackgroundView.userInteractionEnabled=NO;
        _cardBackgroundView.layer.cornerRadius = 8.0f;
        _cardBackgroundView.layer.masksToBounds=YES;
        [self addSubview:_cardBackgroundView];
        
        
        // Player
        
        _playerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cardBackgroundView.frame.size.width, h/15)];
        //_playerBackgroundView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
        _playerBackgroundView.backgroundColor = [UIColor orangeColor];
        [_cardBackgroundView addSubview:_playerBackgroundView];
        
        if(_ivPlayer==nil){
            _ivPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, _playerBackgroundView.frame.size.height-10, _playerBackgroundView.frame.size.height-10)];
        }
        _ivPlayer.backgroundColor = [UIColor grayColor];
        _ivPlayer.contentMode = UIViewContentModeScaleAspectFill;
        _ivPlayer.layer.masksToBounds=YES;
        [_playerBackgroundView addSubview:_ivPlayer];
        
        if(_lblPlayer==nil){
            _lblPlayer = [[UILabel alloc] init];
        }
        _lblPlayer.frame = CGRectMake(_playerBackgroundView.frame.size.height+5, 0, _playerBackgroundView.frame.size.width-(_ivPlayer.frame.size.height+5), _playerBackgroundView.frame.size.height);
        _lblPlayer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lblPlayer.text = @"Held Cards";
        _lblPlayer.backgroundColor = [UIColor clearColor];
        _lblPlayer.textColor = [UIColor whiteColor];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _lblPlayer.font = [UIFont systemFontOfSize:12.0];
        }else{
            _lblPlayer.font = [UIFont systemFontOfSize:16.0];
        }
        
        [_playerBackgroundView addSubview:_lblPlayer];
        
        _btnQuit = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnQuit useRedDeleteStyle];
        _btnQuit.frame = CGRectMake(_playerBackgroundView.frame.size.width-25, 5, 20, 20);
        //_btnNone.backgroundColor = [UIColor redColor];
        [_btnQuit setTitle:@"X" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _btnQuit.titleLabel.font = [UIFont systemFontOfSize:12.0];
        }else{
            _btnQuit.titleLabel.font = [UIFont systemFontOfSize:16.0];
        }
        _btnQuit.titleEdgeInsets = UIEdgeInsetsMake(1, 1, 0, 0);
        //_btnNone.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_btnQuit addTarget:self action:@selector(touchClose:) forControlEvents:UIControlEventTouchUpInside];
        [_cardBackgroundView addSubview:_btnQuit];
        
        // Card
        
        float cardY = _playerBackgroundView.frame.size.height;
        float cardW = _cardBackgroundView.frame.size.width;
        float cardH = _cardBackgroundView.frame.size.height;
        
        if(_svCards==nil){
            
            int inset=0;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                inset=9;
            }
            
            _svCards = [[UIScrollView alloc] initWithFrame:CGRectMake(0, cardY, cardW, cardH-(cardY*3)-inset)]; // 3 for the top, page control, button
        }
        _svCards.pagingEnabled=YES;
        _svCards.delegate=self;
        
        [_cardBackgroundView addSubview:_svCards];
        
        if(_svPageControl==nil){
            
            int inset=0;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                inset=5;
            }
            
            _svPageControl = [[PageControl alloc] initWithFrame:CGRectMake(0, cardY+_svCards.frame.size.height-inset, cardW, 20)];
        }
        _svPageControl.delegate = self;
        _svPageControl.dotColorCurrentPage = [UIColor darkGrayColor];
        _svPageControl.dotColorOtherPage = [UIColor lightGrayColor];
        _svPageControl.hidden=YES;
        _svPageControl.currentPage=0;
        _svPageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_cardBackgroundView addSubview:_svPageControl];
    }
    return self;
}

#pragma mark - Setter

- (void)setGamePlayer:(GamePlayer *)gamePlayer{
    DLog(@"~");
    
    _gamePlayer = gamePlayer;
    
    [_ivPlayer setImage:[UIImage imageWithData:_gamePlayer.player.photo]];
    _lblPlayer.text = [NSString stringWithFormat:@"%@'s Held Cards", _gamePlayer.player.name];
    
    NSPredicate *predicateHeldCards = [NSPredicate predicateWithFormat:@"holding = %@ AND played = %@", [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO]];
    _cards = [[gamePlayer.cards allObjects] filteredArrayUsingPredicate:predicateHeldCards];
    [self buildCards:_cards];
    DLog(@"card count: %i", [_cards count]);
}

- (void)setGame:(Game *)game{
    _game = game;
    
    [_ivPlayer setImage:[UIImage imageNamed:@"defaultUser.png"]];
    
    NSPredicate *predicateHeldCards = [NSPredicate predicateWithFormat:@"holding = %@ AND played = %@", [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO]];
    _cards = [[_game.cards allObjects] filteredArrayUsingPredicate:predicateHeldCards];
    [self buildCards:_cards];
    DLog(@"card count: %i", [_cards count]);
}

- (void)buildCards:(NSArray*)cards{
    DLog(@"~");
    
    float cardY = _playerBackgroundView.frame.size.height;
    float cardW = _cardBackgroundView.frame.size.width;
    
    if([cards count]>0){
        
        _btnPlay = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnPlay useSimpleOrangeStyle];
        
        int inset=0;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            inset=9;
        }
        
        _btnPlay.frame = CGRectMake(20, _svCards.frame.origin.y+_svCards.frame.size.height+cardY-20+inset, cardW-40, cardY);
        //_btnPlay.backgroundColor = [UIColor redColor];
        [_btnPlay setTitle:@"Play Card" forState:UIControlStateNormal];
        //_btnQuit.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_btnPlay addTarget:self action:@selector(playCard) forControlEvents:UIControlEventTouchUpInside];
        [_cardBackgroundView addSubview:_btnPlay];
        
        _svCards.contentSize = CGSizeMake([cards count]*_svCards.frame.size.width, _svCards.frame.size.height);
        
        _svPageControl.hidden=NO;
        _svPageControl.numberOfPages = [cards count];
        
        int i=0;
        for(GameCard *gc in cards){
            
            HeldCardView *hcv = [[HeldCardView alloc] initWithFrame:CGRectMake(i*_svCards.frame.size.width,0,_svCards.frame.size.width, _svCards.frame.size.height) andGameCard:gc];
            [_svCards addSubview:hcv];
            i++;
        }
    }else{
        if(_lblNone==nil){
            _lblNone = [[UILabel alloc] init];
        }
        _lblNone.frame = CGRectMake(0, 0, cardW, _cardBackgroundView.frame.size.height);
        _lblNone.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lblNone.text = @"No cards held";
        _lblNone.backgroundColor = [UIColor clearColor];
        _lblNone.textColor = [UIColor darkGrayColor];
        _lblNone.textAlignment = UITextAlignmentCenter;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _lblNone.font = [UIFont systemFontOfSize:16.0];
        }else{
            _lblNone.font = [UIFont systemFontOfSize:20.0];
        }
        
        [_cardBackgroundView addSubview:_lblNone];
        
        _btnNone = [GradientButton buttonWithType:UIButtonTypeCustom];
        [_btnNone useRedDeleteStyle];
        _btnNone.frame = CGRectMake(20, _cardBackgroundView.frame.size.height-cardY-20, cardW-40, cardY);
        //_btnNone.backgroundColor = [UIColor redColor];
        [_btnNone setTitle:@"Close" forState:UIControlStateNormal];
        //_btnNone.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_btnNone addTarget:self action:@selector(touchClose:) forControlEvents:UIControlEventTouchUpInside];
        [_cardBackgroundView addSubview:_btnNone];
    }
}

#pragma mark - Buttons

- (void)playCard{
    DLog(@"~ playing: %i", _svPageControl.currentPage);
    GameCard *gc = [_cards objectAtIndex:_svPageControl.currentPage];
    
    GameBoardViewController *board = (GameBoardViewController*)_delegate;
    
    gc.played=[NSNumber numberWithBool:YES];
    [gc.managedObjectContext save:nil];
    
    board.currentCard = gc.card;
    board.currentGameCard = gc;
    
    if([_delegate respondsToSelector:@selector(heldCardsPlay:)]){
        [_delegate heldCardsPlay:self];
    }
}

- (void)touchClose:(id)sender{
    DLog(@"~");
    
    if([_delegate respondsToSelector:@selector(heldCardsClose:)]){
        [_delegate heldCardsClose:self];
    }
}

- (void)heldCardsClose:(HeldCardsView*)view{
    // too lazy to get rid of the above error/warning properly
}

- (void)heldCardsPlay:(HeldCardsView*)view{
    // too lazy to get rid of the above error/warning properly
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

#pragma mark - Paging

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView {
    DLog(@"~");
    if (theScrollView == _svCards) {
        
        CGFloat cx = theScrollView.contentOffset.x;
       //NSUInteger index = (NSUInteger)(cx / theScrollView.frame.size.width);
        
        DLog(@"%f %f", cx, theScrollView.frame.size.width);
        
        NSInteger index = (NSUInteger)((NSUInteger)cx / (NSUInteger)theScrollView.frame.size.width);
        DLog(@"%i", index);
        
        _svPageControl.currentPage = index;
    }
    DLog(@"currentpage %i", _svPageControl.currentPage);
}

-(void)pageControlPageDidChange:(PageControl*)thePageControl{
    DLog(@"~");
    
    CGSize size = _svCards.frame.size;
    CGRect rect = CGRectMake(size.width * thePageControl.currentPage, 0, size.width, size.height);
    [_svCards scrollRectToVisible:rect animated:YES];
    
    DLog(@"currentpage %i", _svPageControl.currentPage);
}

/*- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    DLog(@"~");
    
    for(UIView *subview in self.subviews)
    {
        UIView *view = [subview hitTest:[self convertPoint:point toView:subview] withEvent:event];
        
        if(view==_cardBackgroundView){
            return nil;
        }
        
        if(view) return view;
    }
    return [super hitTest:point withEvent:event];
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
