//
//  MainViewController.m
//  MineSweeper
//
//  Created by Qiaoyuan Deng on 2/3/14.
//  Copyright (c) 2014 Qiaoyuan Deng. All rights reserved.
//

#import "MainViewController.h"
#import "GameViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"beginnerGame"]){
        GameViewController *gameView = [segue destinationViewController];
        [gameView segueIsCreated:@"Beginner"];
    }
    else if([segue.identifier isEqualToString:@"intermediateGame"]){
        GameViewController *gameView = [segue destinationViewController];
        [gameView segueIsCreated:@"Intermediate"];
    }
    else if([segue.identifier isEqualToString:@"expertGame"]){
        GameViewController *gameView = [segue destinationViewController];
        [gameView segueIsCreated:@"Expert"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
