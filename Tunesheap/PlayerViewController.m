//
//  PlayerViewController.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "PlayerViewController.h"
#import "THSequencePlayer.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface PlayerViewController () <THSequencePlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *artwork;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UILabel *timePassed;
@property (weak, nonatomic) IBOutlet UILabel *totalLength;
@end

@implementation PlayerViewController

-(void)setSong:(NSDictionary *)newSong {
    if (_song != newSong) {
        _song = newSong;
        [self configureView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIVisualEffectView *effectVview = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectVview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:effectVview aboveSubview:self.artwork];
    
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:effectVview
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.artwork
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:effectVview
                                                                      attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeading
                                                                       multiplier:1.0
                                                                         constant:0.0];
    
    NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem:effectVview
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:0.0];
    
    NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:effectVview
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.songTitle
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:-10.0];
    [self.view addConstraints:@[constraintBottom, constraintLeft, constraintRight, constraintTop]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureView];
    [THSequencePlayer sharedPlayer].delegate = self;
    [self.artwork setImageWithURL:[NSURL URLWithString:self.albumArtworkURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)sliderSlid:(id)sender {
    
}

- (IBAction)nextButtonPressed:(id)sender {
    [[THSequencePlayer sharedPlayer] next];
}

- (IBAction)previousButtonPressed:(id)sender {
    [[THSequencePlayer sharedPlayer] previous];
}

- (IBAction)playPressed:(id)sender {
    if([[THSequencePlayer sharedPlayer] isPlaying]) {
        [[THSequencePlayer sharedPlayer] pause];
    } else {
        [[THSequencePlayer sharedPlayer] play];
    }
    
}

#pragma mark - Player Delegate

-(void)player:(THSequencePlayer *)player playbackDidProgress:(CGFloat)percentPlayed toSecond:(NSInteger)seconds {
    self.progressSlider.value = percentPlayed;
    unsigned long minutes = seconds / 60;
    unsigned long secondsLeft = seconds % 60;
    self.timePassed.text = [NSString stringWithFormat:@"%.2lu:%.2lu", minutes, secondsLeft];
}

#pragma mark - Private API

-(void)configureView {
    self.songTitle.text = self.song[@"name"];
    self.timePassed.text = @"00:00";
    unsigned long minutes = [self.song[@"length"] integerValue] / 60;
    unsigned long seconds = [self.song[@"length"] integerValue] % 60;
    self.totalLength.text = [NSString stringWithFormat:@"%.2lu:%.2lu", minutes, seconds];
}


@end
