//
//  FRVStationSearchViewController.m
//  Velib
//
//  Created by Flavien Raynaud on 18/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVStationSearchViewController.h"
#import "FRVStationSearchCell.h"
#import "FRVContract.h"
#import "FRVStation.h"
#import "FRVStationViewController.h"

@interface FRVStationSearchViewController ()

@property (strong, nonatomic) NSArray* stations;
@property (strong, nonatomic) NSArray* filteredStations;

@property (strong, nonatomic) UISearchController* searchController;

@end

@implementation FRVStationSearchViewController

- (instancetype)initWithStations:(NSArray *)stations
{
    self = [super init];

    if (self) {
        _stations = [stations sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString* first = [(FRVStation*)a name];
            NSString* second = [(FRVStation*)b name];
            return [first compare:second];
        }];

        _filteredStations = [[NSArray alloc] init];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;

    [self.searchController.searchBar sizeToFit];

    self.tableView.tableHeaderView = self.searchController.searchBar;

    UINib* nib = [UINib nibWithNibName:@"FRVStationSearchCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"FRVStationSearchCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [self.filteredStations count];
    } else {
        return [self.stations count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* tableIdentifier = @"FRVStationSearchCell";
    
    FRVStationSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];

    if (!cell) {
        cell = [[FRVStationSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }

    FRVStation* station = nil;

    if (self.searchController.active) {
        station = [self.filteredStations objectAtIndex:indexPath.row];
    }
    else {
        station = [self.stations objectAtIndex:indexPath.row];
    }

    cell.nameLabel.text = station.name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRVStation* station = nil;

    if (self.searchController.active) {
        station = [self.filteredStations objectAtIndex:indexPath.row];
    } else {
        station = [self.stations objectAtIndex:indexPath.row];
    }

    FRVStationViewController* svc = [[FRVStationViewController alloc] initWithStation:station];

    self.searchController.active = NO;
    [self presentViewController:svc animated:YES completion:nil];
}

#pragma mark - Search methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
{
    if ([searchText length] == 0) {
        self.filteredStations = self.stations;
    } else {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        self.filteredStations = [self.stations filteredArrayUsingPredicate:resultPredicate];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];

    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

@end
