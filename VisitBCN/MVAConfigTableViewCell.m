//
//  MVAConfigTableViewCell.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 26/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAConfigTableViewCell.h"

@interface MVAConfigTableViewCell()

@property SevenSwitch *mySwitch;

@end

@implementation MVAConfigTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)configSwitch
{
    int alg = 1;
    BOOL dijkstra = YES;
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSData *data = [defaults objectForKey:self.objectName];
    if(data == nil){
        [defaults setInteger:1 forKey:self.objectName];
    }
    else {
        alg = (int)[defaults integerForKey:self.objectName];
    }
    if(alg == 0) {
        dijkstra = NO;
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) self.label.text = @"Algorithm: A*";
        else self.label.text = @"Is raining in Barcelona? NO";
    }
    else {
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) self.label.text = @"Algorithm: Dijkstra";
        else self.label.text = @"Is raining in Barcelona? YES";
    }
    if (self.mySwitch == nil) {
        self.mySwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(0, 0, self.cellSwitch.frame.size.width, self.cellSwitch.frame.size.height)];
        [self.mySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) {
            self.mySwitch.offImage = [UIImage imageNamed:@"astar"];
            self.mySwitch.onImage = [UIImage imageNamed:@"dijkstra"];
        }
        else {
            self.mySwitch.offImage = [UIImage imageNamed:@"cross"];
            self.mySwitch.onImage = [UIImage imageNamed:@"check"];
        }
        self.mySwitch.onTintColor = self.cellSwitch.backgroundColor;
        [self.mySwitch setBackgroundColor:[UIColor clearColor]];
        self.mySwitch.isRounded = NO;
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) self.mySwitch.borderColor = [UIColor orangeColor];
        else self.mySwitch.borderColor = [UIColor lightGrayColor];
        [self.cellSwitch addSubview:self.mySwitch];
        [self.mySwitch setOn:dijkstra animated:YES];
        if (dijkstra) [self.mySwitch setThumbTintColor:[UIColor whiteColor]];
        else {
            if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) [self.mySwitch setThumbTintColor:[UIColor whiteColor]];
            else [self.mySwitch setThumbTintColor:[UIColor lightGrayColor]];
        }
    }
    if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) [self.cellSwitch setBackgroundColor:[UIColor orangeColor]];
    else [self.cellSwitch setBackgroundColor:[UIColor clearColor]];
}

- (void)switchChanged:(SevenSwitch *)sender {
    int alg = 1;
    BOOL dijkstra = YES;
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSData *data = [defaults objectForKey:self.objectName];
    if(data == nil){
        [defaults setInteger:1 forKey:self.objectName];
    }
    else {
        alg = (int)[defaults integerForKey:self.objectName];
    }
    if(alg == 0) {
        dijkstra = NO;
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) self.label.text = @"Algorithm: A*";
        else self.label.text = @"Is raining in Barcelona? NO";
    }
    else {
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) self.label.text = @"Algorithm: Dijkstra";
        else self.label.text = @"Is raining in Barcelona? YES";
    }
    dijkstra = !dijkstra;
    if(dijkstra) {
        [sender setThumbTintColor:[UIColor whiteColor]];
        [self saveAlgorithm:dijkstra];
        [self.papi.tableView reloadData];
    }
    else {
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) [sender setThumbTintColor:[UIColor whiteColor]];
        else [sender setThumbTintColor:[UIColor lightGrayColor]];
        [self saveAlgorithm:dijkstra];
        [self.papi.tableView reloadData];
    }
}

-(void)saveAlgorithm:(BOOL)alarmaPermitida
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    if (alarmaPermitida) [defaults setInteger:1 forKey:self.objectName];
    else [defaults setInteger:0 forKey:self.objectName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
