//
//  THSongTableViewCell.h
//  Tunesheap
//
//  Created by Robert Lis on 25/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THSongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@end
