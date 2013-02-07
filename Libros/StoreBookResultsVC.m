//
//  StoreVC.m
//  Libros
//
//  Created by Sean Hess on 1/10/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StoreBookResultsVC.h"
#import "BookService.h"
#import "Book.h"
#import "ObjectStore.h"
#import "UserService.h"
#import "StoreBookCell.h"
#import "StoreDetailsVC.h"
#import "StoreBookResultsFilterView.h"

@interface StoreBookResultsVC ()

@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;
@property (nonatomic) BookFilter currentFilter;
@property (nonatomic, strong) NSPredicate * originalPredicate;
@property (nonatomic, strong) StoreBookResultsFilterView * filterView;

@end

@implementation StoreBookResultsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentFilter = BookFilterEverything;
    self.originalPredicate = self.fetchRequest.predicate;
    [self generateFetchedResults];
    
    // needs to be ANY details view controller has this
    // not just the popular one :(
    
    // meh, just do it like this, or load it from its own nib
    
    self.filterView = [StoreBookResultsFilterView filterView];
    [self.filterView setDelegate:self];
    self.tableView.tableHeaderView = self.filterView;
    [self.tableView setContentOffset:CGPointMake(0, self.filterView.frame.size.height)];
    [self renderFilterTitle];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)generateFetchedResults {
    NSPredicate * filterPredicate  = [BookService.shared filterByType:self.currentFilter];
    
    if (self.originalPredicate && filterPredicate) {
        self.fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[filterPredicate, self.originalPredicate]];
    }
    
    else if (self.originalPredicate)  {
        self.fetchRequest.predicate = self.originalPredicate;
    }
    
    else {
        self.fetchRequest.predicate = filterPredicate;
    }
    
    NSAssert(self.fetchRequest, @"Must set fetch request before viewDidLoad on StoreBookResultsVC");
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:ObjectStore.shared.context sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
}

#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSIndexPath*)localIndexPath:(NSIndexPath*)indexPath {
    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoreBookCell";
    StoreBookCell *cell = (StoreBookCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StoreBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Book * book = [self.fetchedResultsController objectAtIndexPath:[self localIndexPath:indexPath]];
    cell.book = book;
    
    return cell;
}

#pragma mark - Filtering

- (void)renderFilterTitle {
    if (self.currentFilter == BookFilterEverything) self.filterView.buttonTitle = @"Filter: Everything";
    else if (self.currentFilter == BookFilterHasText) self.filterView.buttonTitle = @"Filter: Has Text";
    else if (self.currentFilter == BookFilterHasAudio) self.filterView.buttonTitle = @"Filter: Has Audio";
}

- (void)didTapFilterButton {
    StoreFilterVC * filters = [StoreFilterVC new];
    filters.delegate = self;
    filters.filter = self.currentFilter;
    [self.navigationController presentViewController:filters animated:YES completion:nil];
}

- (void)didSelectFilter:(BookFilter)filter {
    self.currentFilter = filter;
    [self generateFetchedResults];
    [self.tableView reloadData];
    [self renderFilterTitle];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Book * book = [self.fetchedResultsController objectAtIndexPath:[self localIndexPath:indexPath]];
    StoreDetailsVC * details = [StoreDetailsVC new];
    details.book = book;
    [self.navigationController pushViewController:details animated:YES];
}


@end
