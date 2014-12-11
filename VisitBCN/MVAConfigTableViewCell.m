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
    int alg = 0;
    BOOL dijkstra = YES;
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *data = [defaults objectForKey:self.objectName];
    if(data == nil){
        if ([self.objectName isEqualToString:@"VisitBCNRain"]) [defaults setInteger:0 forKey:self.objectName];
        else {
            [defaults setInteger:1 forKey:self.objectName];
            alg = 1;
        }
    }
    else {
        alg = (int)[defaults integerForKey:self.objectName];
    }
    if(alg == 0) {
        dijkstra = NO;
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) self.label.text = @"Algorithm: A*";
        else if ([self.objectName isEqualToString:@"VisitBCNRain"]) self.label.text = @"Is raining in Barcelona? NO";
        else self.label.text = @"Taxi service: Hailo";
    }
    else {
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) self.label.text = @"Algorithm: Dijkstra";
        else if ([self.objectName isEqualToString:@"VisitBCNRain"]) self.label.text = @"Is raining in Barcelona? YES";
        else self.label.text = @"Taxi service: Uber";
    }
    if (self.mySwitch == nil) {
        self.mySwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(0, 0, self.cellSwitch.frame.size.width, self.cellSwitch.frame.size.height)];
        [self.mySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) {
        self.mySwitch.offImage = [UIImage imageNamed:@"astar"];
        self.mySwitch.onImage = [UIImage imageNamed:@"dijkstra"];
    }
    else if ([self.objectName isEqualToString:@"VisitBCNRain"]) {
        self.mySwitch.offImage = [UIImage imageNamed:@"cross"];
        self.mySwitch.onImage = [UIImage imageNamed:@"check"];
    }
    else {
        self.mySwitch.offImage = [UIImage imageNamed:@"hailo_orange"];
        self.mySwitch.onImage = [UIImage imageNamed:@"uber_black"];
        
    }
    
    self.mySwitch.onTintColor = self.cellSwitch.backgroundColor;
    [self.mySwitch setBackgroundColor:[UIColor clearColor]];
    self.mySwitch.isRounded = NO;
    
    if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) self.mySwitch.borderColor = [UIColor orangeColor];
    else if ([self.objectName isEqualToString:@"VisitBCNRain"]) self.mySwitch.borderColor = [UIColor lightGrayColor];
    else self.mySwitch.borderColor = [UIColor colorWithRed:(243.0f/255.0f) green:(181.0f/255.0f) blue:(59.0f/255.0f) alpha:1.0f];
    
    [self.cellSwitch addSubview:self.mySwitch];
    [self.mySwitch setOn:dijkstra animated:YES];
    if (dijkstra) [self.mySwitch setThumbTintColor:[UIColor whiteColor]];
    else {
        if ([self.objectName isEqualToString:@"VisitBCNRain"]) [self.mySwitch setThumbTintColor:[UIColor lightGrayColor]];
        else [self.mySwitch setThumbTintColor:[UIColor whiteColor]];
    }
    if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) [self.cellSwitch setBackgroundColor:[UIColor orangeColor]];
    else if ([self.objectName isEqualToString:@"VisitBCNRain"]) [self.cellSwitch setBackgroundColor:[UIColor clearColor]];
    else [self.cellSwitch setBackgroundColor:[UIColor colorWithRed:(243.0f/255.0f) green:(181.0f/255.0f) blue:(59.0f/255.0f) alpha:1.0f]];
}

- (void)switchChanged:(SevenSwitch *)sender {
    BOOL dijkstra = sender.on;
    if(dijkstra) {
        if ([self.objectName isEqualToString:@"VisitBCNRain"]) [sender setThumbTintColor:[UIColor lightGrayColor]];
        else [sender setThumbTintColor:[UIColor whiteColor]];
        [self saveAlgorithm:dijkstra];
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) self.label.text = @"Algorithm: Dijkstra";
        else if ([self.objectName isEqualToString:@"VisitBCNRain"]) self.label.text = @"Is raining in Barcelona? YES";
        else self.label.text = @"Taxi service: Uber";
    }
    else {
        [sender setThumbTintColor:[UIColor whiteColor]];
        [self saveAlgorithm:dijkstra];
        if ([self.objectName isEqualToString:@"VisitBCNAlgorithm"]) self.label.text = @"Algorithm: A*";
        else if ([self.objectName isEqualToString:@"VisitBCNRain"]) self.label.text = @"Is raining in Barcelona? NO";
        else self.label.text = @"Taxi service: Hailo";
    }
}

-(void)saveAlgorithm:(BOOL)alarmaPermitida
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    if (alarmaPermitida) [defaults setInteger:1 forKey:self.objectName];
    else [defaults setInteger:0 forKey:self.objectName];
}

@end
