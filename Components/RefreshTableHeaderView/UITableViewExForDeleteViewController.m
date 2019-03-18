//
//  UITableViewExForDeleteViewController.m
//  HIChat
//
//  Created by Song Ques on 14-6-10.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import "UITableViewExForDeleteViewController.h"

@interface UITableViewExForDeleteViewController ()

@end

@implementation UITableViewExForDeleteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return UITableViewCellEditingStyleNone;
    //    return UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(self.delegateCustom&&self.delegateCustom!=nil)
        {
            [self.delegateCustom tableForDelete:[self.dataSource objectAtIndex:indexPath.row]];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
    
}

@end
