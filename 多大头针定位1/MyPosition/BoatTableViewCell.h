//
//  BoatTableViewCell.h
//  MyPosition
//
//  Created by apple4 on 16/7/21.
//  Copyright © 2016年 apple4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoatTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *boatImage;
@property (strong, nonatomic) IBOutlet UILabel *boatNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *boatMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *diatanceLabel;

@end
