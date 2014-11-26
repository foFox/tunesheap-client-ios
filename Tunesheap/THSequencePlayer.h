//
//  THSequencePlayer.h
//  Tunesheap
//
//  Created by Robert Lis on 26/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class THSequencePlayer;

@protocol THSequencePlayerDelegate <NSObject>
@optional
-(void)player:(THSequencePlayer *)player playbackDidProgress:(CGFloat)percentPlayed toSecond:(NSInteger)seconds;
@end

@interface THSequencePlayer : AVPlayer
@property (nonatomic, readwrite, weak) id <THSequencePlayerDelegate> delegate;
+(instancetype)sharedPlayer;
-(BOOL)isPlaying;
-(void)setItemsToPlay:(NSArray *)items startAt:(NSInteger)itemIndex;
-(void)next;
-(void)previous;
@end
