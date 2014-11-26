//
//  THSequencePlayer.m
//  Tunesheap
//
//  Created by Robert Lis on 26/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "THSequencePlayer.h"

@interface THSequencePlayer()
@property NSArray *items;
@property NSUInteger currentItemIndex;
@property NSTimer *playbackTimer;
@end

@implementation THSequencePlayer
+(instancetype)sharedPlayer {
    static dispatch_once_t onceToken;
    static THSequencePlayer *player;
    dispatch_once(&onceToken, ^{
        player = [[THSequencePlayer alloc] init];
    });
    
    return player;
}

#pragma mark - Public API

-(instancetype)init {
    self = [super init];
    if(self) {
        [self addObserver:self forKeyPath:@"status" options:0 context:nil];
        self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];

    }
    
    return self;
}

-(BOOL)isPlaying {
    return self.rate > 0.0;
}

-(void)setItemsToPlay:(NSArray *)items startAt:(NSInteger)itemIndex {
    self.items = items;
    self.currentItemIndex = itemIndex % self.items.count;
    [self playCurrentItem];
}

-(void)next {
    self.currentItemIndex = ++self.currentItemIndex % self.items.count;
    [self playCurrentItem];
}

-(void)previous {
    self.currentItemIndex = --self.currentItemIndex % self.items.count;
    [self playCurrentItem];
}

#pragma mark - Private API

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"status"]) {
        if (self.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
        } else if (self.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [self play];
        } else if (self.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}

-(void)updateProgress:(NSTimer *)timer {
    if([self isPlaying]) {
        CGFloat percentPlayed = CMTimeGetSeconds(self.currentTime) / CMTimeGetSeconds(self.currentItem.duration);
        [self.delegate player:self playbackDidProgress:percentPlayed toSecond:CMTimeGetSeconds(self.currentTime)];
    }
}

-(void)playerItemDidReachEnd:(NSNotification *)notification {
    [self next];
}

-(void)playCurrentItem {
    [self replaceCurrentItemWithPlayerItem:self.items[self.currentItemIndex]];
}

#pragma mark - Other

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"status" object:nil];
}

@end
