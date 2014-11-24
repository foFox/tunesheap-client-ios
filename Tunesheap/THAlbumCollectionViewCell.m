//
//  THAlbumCollectionViewCell.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "THAlbumCollectionViewCell.h"

@implementation THAlbumCollectionViewCell
-(void)awakeFromNib {
    self.artwork.layer.cornerRadius = 5.0f;
    self.artwork.layer.borderColor = [UIColor whiteColor].CGColor;
    self.artwork.layer.borderWidth =  1.0f;
}
@end
