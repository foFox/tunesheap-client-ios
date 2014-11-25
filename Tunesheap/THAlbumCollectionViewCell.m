//
//  THAlbumCollectionViewCell.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "THAlbumCollectionViewCell.h"

@implementation THAlbumCollectionViewCell

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attr = [layoutAttributes copy];
    CGSize size = [self.title sizeThatFits:CGSizeMake(150,CGFLOAT_MAX)];
    CGRect newFrame = attr.frame;
    newFrame.size.height -= self.title.bounds.size.height;
    newFrame.size.height += size.height + 20;
    attr.frame = newFrame;
    self.artwork.layer.cornerRadius = self.artwork.bounds.size.height / 2;
    return attr;
}

-(void)awakeFromNib {
    self.artwork.layer.cornerRadius = 5.0f;
    self.artwork.layer.borderColor = [UIColor whiteColor].CGColor;
    self.artwork.layer.borderWidth =  1.0f;
    self.artwork.backgroundColor = [UIColor whiteColor];
    self.artwork.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0;
    self.title.edgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
}
@end
