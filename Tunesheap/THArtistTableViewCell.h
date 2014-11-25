//
//  THArtistTableCellTableViewCell.h
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THArtistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *artistCountry;
@property (weak, nonatomic) IBOutlet UILabel *artistBirthday;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIImageView *artistThumbnail;
@end
