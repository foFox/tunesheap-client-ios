//
//  THAlbumCollectionViewCell.h
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THAlbumCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artwork;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
