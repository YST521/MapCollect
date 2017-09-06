//
//  BoatListViewController.m
//  MyPosition
//
//  Created by apple4 on 16/7/21.
//  Copyright © 2016年 apple4. All rights reserved.
//

#import "BoatListViewController.h"
#import "BoatTableViewCell.h"
#import "BoatTraViewController.h"

@interface BoatListViewController ()

{
    NSMutableDictionary* data;
    NSMutableDictionary* position;
    NSString* name;
    NSString* adress;
}

@end

@implementation BoatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"船舶列表";
    
    self.boatListView.delegate = self;
    self.boatListView.dataSource = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"position" ofType:@"plist"];
    data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Utilities_NavigationBar"] forBarMetrics:UIBarMetricsDefault];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"BoatTableViewCell";
    BoatTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"BoatTableViewCell"
                                                      owner:nil
                                                    options:nil];
        cell = [nibs lastObject];
    }
    
    NSString* key = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    NSMutableDictionary *positionDic = [data valueForKey:key];
    NSLog(@"%@",positionDic);

    cell.boatNameLabel.text = [positionDic valueForKey:@"name"];
    cell.boatMessageLabel.text = [positionDic valueForKey:@"address"];

    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 75;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BoatTraViewController* boatTraVC = [[BoatTraViewController alloc]initWithNibName:@"BoatTraViewController" bundle:nil];
    [self.navigationController pushViewController:boatTraVC animated:YES];
}
@end
