//
//  PlayerViewController.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()
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
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)sliderSlid:(id)sender {
    
}


- (IBAction)nextButtonPressed:(id)sender {
    
}

- (IBAction)previousButtonPressed:(id)sender {
    
}

- (IBAction)playPressed:(id)sender {
    
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
