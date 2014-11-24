//
//  SongsViewController.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "SongsViewController.h"
#import "THClient.h"

@interface SongsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *songsTable;
@property (nonatomic, strong) NSArray *songs;
@end

@implementation SongsViewController

-(void)setAlbum:(NSDictionary *)newAlbum {
    if(_album != newAlbum) {
        _album = newAlbum;
        [self configureView];
        [self getSongsFromAlbumWithID:_album[@"id"] success:^(NSArray *songs) {
            self.songs = songs;
            [self.songsTable reloadData];
        } failure:nil];
    }
}

-(void)configureView {
    self.navigationItem.title = self.album[@"name"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table View Data Source 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"song_cell" forIndexPath:indexPath];
    NSDictionary *song = self.songs[indexPath.row];
    cell.textLabel.text = song[@"name"];
    return cell;
}

#pragma mark - Private API

-(void)getSongsFromAlbumWithID:(NSString *)identifier success:(void (^)(NSArray *songs))successBlock failure:(void (^)(NSError *error))failureBlock {
    NSString *url = [NSString stringWithFormat:@"albums/%@/songs", identifier];
    [[THClient sharedClient] GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(successBlock) successBlock(responseObject[@"songs"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}



@end
