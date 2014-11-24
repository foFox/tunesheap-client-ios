//
//  MasterViewController.m
//  Tunesheap
//
//  Created by Robert Lis on 24/11/2014.
//  Copyright (c) 2014 Robert Lis. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "THClient.h"

@interface MasterViewController ()
@property NSArray *artists;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLoad {
    [self getArtists:^(NSArray *artists) {
        self.artists = artists;
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *artist = self.artists[indexPath.row];
    cell.textLabel.text = artist[@"name"];
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
