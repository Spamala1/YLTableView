//
//  YLTableViewDataSourceTests.m
//  YLTableView
//
//  Created by Ushhud Khalid on 12/9/15.
//  Copyright © 2015 Yelp. All rights reserved.
//

#import "YLTableView.h"
#import "YLTableViewCell.h"
#import "YLTableViewCellEstimatedRowHeight.h"
#import "YLTableViewCellTestStub.h"
#import "YLTableViewDataSource.h"
#import "YLTableViewDataSourceTestStub.h"

#import <XCTest/XCTestCase.h>

@interface YLTableViewDataSourceTests : XCTestCase

@property (strong, nonatomic) YLTableView *tableView;
@property (strong, nonatomic) YLTableViewDataSourceTestStub *dataSource;

@end

@implementation YLTableViewDataSourceTests

static const int kSectionIndexTableView = 0;
static const int kRowIndexTableViewConformingCell = 0;
static const int kRowIndexTableViewNonConformingCell = 1;

#pragma mark - Setup/Teardown

- (void)setUp {
  [super setUp];
  
  _tableView = [[YLTableView alloc] init];
  _dataSource = [[YLTableViewDataSourceTestStub alloc] init];
  _tableView.dataSource = _dataSource;
  _tableView.delegate = _dataSource;
  
  _dataSource.tableViewCells = [self _cellsForTableView];
}

#pragma mark - Helpers

- (NSDictionary<NSIndexPath *, YLTableViewCell * > *)_cellsForTableView {
  return @{
    [self _indexPathForConformingCell]: [[YLTableViewCellTestStub alloc] init],
    [self _indexPathForNonConformingCell]: [[YLTableViewCell alloc] init],
  };
}

- (NSIndexPath *)_indexPathForConformingCell {
  return [NSIndexPath indexPathForRow:kRowIndexTableViewConformingCell inSection:kSectionIndexTableView];
}

- (NSIndexPath *)_indexPathForNonConformingCell {
  return [NSIndexPath indexPathForRow:kRowIndexTableViewNonConformingCell inSection:kSectionIndexTableView];
}

#pragma mark - Tests

- (void)_testEstimatedRowHeightForIndexPath:(NSIndexPath *)indexPath withExpectedHeight:(CGFloat)expectedHeight {
  CGFloat height = [self.dataSource tableView:self.tableView estimatedHeightForRowAtIndexPath:indexPath];
  XCTAssertEqual(height, expectedHeight);
}

- (void)testThatEstimatedRowHeightIsFromCellConformingProtocol {
  self.dataSource.shouldProvideOverriddenHeight = NO;
  [self _testEstimatedRowHeightForIndexPath:[self _indexPathForConformingCell] withExpectedHeight:kYLTableViewCellStubHeight];
}

- (void)testThatEstimatedRowHeightIsFromCellConformingProtocolEvenWithAlternateMethod {
  self.dataSource.shouldProvideOverriddenHeight = YES;
  [self _testEstimatedRowHeightForIndexPath:[self _indexPathForConformingCell] withExpectedHeight:kYLTableViewCellStubHeight];
}

- (void)testThatEstimatedRowHeightIsFromAlternateMethodForNonConformingCell {
  self.dataSource.shouldProvideOverriddenHeight = YES;
  [self _testEstimatedRowHeightForIndexPath:[self _indexPathForNonConformingCell] withExpectedHeight:kYLTableViewDataSourceTestStubOverriddenHeight];
}

- (void)testThatEstimatedRowHeightIsDefault {
  self.dataSource.shouldProvideOverriddenHeight = NO;
  [self _testEstimatedRowHeightForIndexPath:[self _indexPathForNonConformingCell] withExpectedHeight:UITableViewAutomaticDimension];
}

@end
