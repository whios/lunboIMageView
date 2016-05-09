//
//  ViewController.m
//  HibiaoScrollWithImage
//
//  Created by 黄彪 on 16/5/7.
//  Copyright © 2016年 黄彪. All rights reserved.
//

#import "ViewController.h"
#import "HibiaoScrollWithImageView.h"

@interface ViewController ()<HibiaoScrollWithImageViewDelegate>
@property (nonatomic, strong) HibiaoScrollWithImageView *hibiaoScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * array = @[@{@"color":[UIColor redColor], @"jump":@"red"},@{@"color":[UIColor blueColor], @"jump":@"blue"},@{@"color":[UIColor yellowColor], @"jump":@"yellow"},@{@"color":[UIColor orangeColor], @"jump":@"orange"}];
    self.hibiaoScrollView = [[HibiaoScrollWithImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 100)direction:Horizontal dataSourceArray:array];
    _hibiaoScrollView.delegate= self;
    [self.view addSubview:_hibiaoScrollView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 100, 30)];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"改变数据" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(creatData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(160, 200, 100, 30)];
    button1.backgroundColor = [UIColor orangeColor];
    [button1 setTitle:@"改变方向" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(changeDirection:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    // Do any additional setup after loading the view.
}

- (void)creatData:(UIButton *)button {
    NSArray * array = @[@{@"color":[UIColor yellowColor], @"jump":@"yellow"},@{@"color":[UIColor blueColor], @"jump":@"blue"},@{@"color":[UIColor redColor], @"jump":@"red"}];
    self.hibiaoScrollView.dataSourceArray = array;
}

- (void)changeDirection:(UIButton *)button {
    if (self.hibiaoScrollView.direction == Horizontal) {
        self.hibiaoScrollView.direction = Vertical;
        return;
    }
    if (self.hibiaoScrollView.direction == Vertical) {
        self.hibiaoScrollView.direction = Horizontal;
        return;
    }
}

- (void)clickedImageViewWithButton:(UIButton *)button {
    NSLog(@"%@", [[_hibiaoScrollView.dataSourceArray objectAtIndex:button.tag] objectForKey:@"jump"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
