//
//  BoatListViewController.h
//  MyPosition
//
//  Created by apple4 on 16/7/21.
//  Copyright © 2016年 apple4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoatListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *boatListView;

@end
