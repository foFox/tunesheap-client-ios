//
//  DetailViewController.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "DetailViewController.h"
#import "THAlbumCollectionViewCell.h"
#import "THClient.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *albumsCollectionView;
@property (strong, nonatomic) NSArray *albums;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setArtist:(NSDictionary *)newArtist {
    if (_artist != newArtist) {
        _artist = newArtist;
        [self configureView];
        [self getAlbumsOfArtistWithID:_artist[@"id"] success:^(NSArray *albums) {
            self.albums = albums;
            [self.albumsCollectionView reloadData];
        } failure:nil];
        
    }
}

- (void)configureView {
    if (self.artist) {
        self.navigationItem.title = self.artist[@"name"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    ((UICollectionViewFlowLayout *)self.albumsCollectionView.collectionViewLayout).estimatedItemSize = CGSizeMake(150, 150);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"album_cell" forIndexPath:indexPath];
    NSDictionary *album = self.albums[indexPath.row];
    cell.title.text = album[@"name"];
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"show_album" sender:self.albumsCollectionView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"show_album"]) {
        if([segue.destinationViewController respondsToSelector:NSSelectorFromString(@"album")]) {
            if([sender isKindOfClass:UICollectionView.class])
            {
                NSIndexPath *selectedPath = [(UICollectionView *)sender indexPathsForSelectedItems].firstObject;
                NSDictionary *album = self.albums[selectedPath.item];
                [segue.destinationViewController setValue:album forKey:@"album"];
            }
        }
    }
}

#pragma mark - Private API

-(void)getAlbumsOfArtistWithID:(NSString *)identifier success:(void (^)(NSArray *albums))successBlock failure:(void (^)(NSError *error))failureBlock {
    NSString *url = [NSString stringWithFormat:@"artists/%@/albums", identifier];
    [[THClient sharedClient] GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(successBlock) successBlock(responseObject[@"albums"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


@end
