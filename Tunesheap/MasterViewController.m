//
//  MasterViewController.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "THArtistTableViewCell.h"
#import "THClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MasterViewController ()
@property NSArray *artists;
@property NSDateFormatter *formatterFrom;
@property NSDateFormatter *formatterTo;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLoad {
    [self getArtists:^(NSArray *artists) {
        self.artists = artists;
        [self.tableView reloadData];
    } failure:nil];
    self.formatterFrom = [[NSDateFormatter alloc] init];
    [self.formatterFrom setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];

    self.formatterTo = [[NSDateFormatter alloc] init];
    self.formatterTo.dateFormat = @"MMMM d YYYY";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor colorWithRed:191.0/255.0f green:24.0/255.0f blue:49.0/255.0f alpha:1.0];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"show_albums"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *artist = self.artists[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setArtist:artist];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artists.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"show_albums" sender:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THArtistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"artist_cell" forIndexPath:indexPath];
    NSDictionary *artist = self.artists[indexPath.row];
    cell.artistName.text = artist[@"name"];
    cell.artistCountry.text = artist[@"country"];
    NSDate *date = [self.formatterFrom dateFromString:artist[@"dob"]];    
    cell.artistBirthday.text = [self.formatterTo stringFromDate:date];
    [cell.artistThumbnail setImageWithURL:[NSURL URLWithString:artist[@"picture_url"]]];
    return cell;
}

#pragma mark - Private API

-(void)getArtists:(void (^)(NSArray *artists))successBlock failure:(void (^)(NSError *error))failureBlock {
    [[THClient sharedClient] GET:@"artists" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(successBlock) successBlock(responseObject[@"artists"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

@end
