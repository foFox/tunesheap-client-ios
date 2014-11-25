//
//  SongsViewController.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "SongsViewController.h"
#import "THClient.h"
#import "THSongTableViewCell.h"

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
    self.songsTable.estimatedRowHeight = 62.0;
    self.songsTable.rowHeight = UITableViewAutomaticDimension;
    self.songsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.songsTable.separatorColor = [UIColor colorWithRed:191.0/255.0f green:24.0/255.0f blue:49.0/255.0f alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table View Data Source 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"song_cell" forIndexPath:indexPath];
    NSDictionary *song = self.songs[indexPath.row];
    cell.trackName.text = song[@"name"];
    unsigned long minutes = [song[@"length"] integerValue] / 60;
    unsigned long seconds = [song[@"length"] integerValue] % 60;
    cell.duration.text = [NSString stringWithFormat:@"%.2lu:%.2lu", minutes, seconds];
    cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    UIView *selectedBackground = [[UIView alloc] init];
    selectedBackground.backgroundColor = [UIColor colorWithRed:191.0/255.0f green:24.0/255.0f blue:49.0/255.0f alpha:0.3];
    [cell setSelectedBackgroundView:selectedBackground];
    return cell;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *songSelected = self.songs[indexPath.row];
    [self performSegueWithIdentifier:@"play_song" sender:songSelected];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"play_song"]) {
        if([segue.destinationViewController respondsToSelector:NSSelectorFromString(@"song")]) {
            [segue.destinationViewController setValue:sender forKey:@"song"];
            [segue.destinationViewController navigationItem].title = self.album[@"name"];
        }
    }
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
