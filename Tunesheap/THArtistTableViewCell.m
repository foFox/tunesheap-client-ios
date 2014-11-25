//
//  THArtistTableCellTableViewCell.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "THArtistTableViewCell.h"

@implementation THArtistTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.artistThumbnail.layer.cornerRadius = self.artistThumbnail.bounds.size.width / 2;
    self.artistThumbnail.layer.borderColor = [UIColor colorWithRed:191.0/255.0f green:24.0/255.0f blue:49.0/255.0f alpha:1.0].CGColor;
    self.artistThumbnail.layer.borderWidth = 2.0;
    [[self.artistThumbnail layer] setMagnificationFilter:kCAFilterNearest];
    [[self.moreButton.imageView layer] setMagnificationFilter:kCAFilterNearest];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
