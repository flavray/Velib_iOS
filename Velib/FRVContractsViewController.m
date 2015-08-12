//
//  FRVContractsViewController.m
//  Velib
//
//  Created by Flavien Raynaud on 09/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVContractsViewController.h"
#import "FRVContract.h"
#import "FRVContractStore.h"
#import "FRVContractCell.h"

@interface FRVContractsViewController ()

@end

@implementation FRVContractsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];

    if (self) {
        [self.navigationItem setTitle:@"Contracts"];

        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                                target:self
                                                                                                action:@selector(refresh:)]];

        _contracts = [[FRVContractStore sharedStore] allItems];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib* nib = [UINib nibWithNibName:@"FRVContractCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"FRVContractCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateTableForDynamicTypeSize];
}

#pragma mark - Cell methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contracts count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRVContractCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FRVContractCell"];

    FRVContract* contract = [[self contracts] objectAtIndex:indexPath.row];

    cell.nameLabel.text = contract.name;
    cell.stationsCountLabel.text = [NSString stringWithFormat:@"%d stations",contract.stationsCount];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // FRVContract* contract = [[self contracts] objectAtIndex:indexPath.row];

    // FRVContractViewController* cvc = [[FRVContractViewController alloc] initWithContract:contract];

    // [self.navigationController pushViewController:cvc animated:YES];
}

# pragma mark - Refresh

- (void)refresh:(id)sender
{
    [[FRVContractStore sharedStore] refresh];

    self.contracts = [[FRVContractStore sharedStore] allItems];

    [self.tableView reloadData];
}

#pragma mark - Dynamic Type

- (void)updateTableForDynamicTypeSize
{
    static NSDictionary* cellHeightDictionary = nil;

    if (!cellHeightDictionary) {
        cellHeightDictionary = @{UIContentSizeCategoryExtraSmall: @44,
                                 UIContentSizeCategorySmall: @44,
                                 UIContentSizeCategoryMedium: @44,
                                 UIContentSizeCategoryLarge: @44,
                                 UIContentSizeCategoryExtraLarge: @55,
                                 UIContentSizeCategoryExtraExtraLarge: @65,
                                 UIContentSizeCategoryExtraExtraExtraLarge: @75};
    }

    NSNumber* cellHeight = [cellHeightDictionary objectForKey:[[UIApplication sharedApplication] preferredContentSizeCategory]];

    [self.tableView setRowHeight:[cellHeight floatValue]];
    [self.tableView reloadData];
}

@end
