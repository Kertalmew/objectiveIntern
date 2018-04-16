//
//  ViewController.m
//  ViewAnimator
//
//  Created by intern on 16/04/2018.
//  Copyright © 2018 intern. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField* speedTF;
@property (nonatomic, retain) IBOutlet UITextField* countTF;
@property (nonatomic, retain) IBOutlet UIButton* runButton;
@property (nonatomic, retain) IBOutlet UIImageView* image;
@property (nonatomic, assign) int speed;
@property (nonatomic, assign) int countSquares;
@property (nonatomic, assign) int radius;
@property (nonatomic, assign) double angle;
@property (nonatomic, assign) BOOL work;
@property (nonatomic, retain) NSArray* titles;
@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic) CGPoint axis;
@property (nonatomic, retain) NSMutableArray* squares;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = [NSArray arrayWithObjects:[self.runButton currentTitle], @"Stop", nil];
    self.speed = 10;
    self.countSquares = 1;
    self.axis = self.image.center;
    self.radius = 100;
    self.angle = -3.1415 / 2;
    
    self.squares = [NSMutableArray new];
    

    [self.squares addObject:self.image];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillDisappear{
    [self.squares release];
    [self.titles release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) didTapButton:(id)sender {
//    [self.speedTF resignFirstResponder];
//    [self.countTF resignFirstResponder];
   // self.speed = [self.speedTF.text intValue];
    if([self.runButton isSelected]){
        self.speed = 100;
    }
//    if([self.runButton state] == UIControlStateFocused){
    if([self.runButton.currentTitle isEqualToString:[self.titles objectAtIndex:0]]){
        //проверка
        if([self.speedTF.text intValue] == 0 || [self.countTF.text intValue] < 1){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Wrong params"
                                                                           message:@"Input parameters is incorrect."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            //need release????
            return;
        }
        [self.countTF setEnabled:NO];
        [self.speedTF setEnabled:NO];
        [self.runButton setTitle:[self.titles objectAtIndex:1] forState: UIControlStateNormal];
        self.work = YES;
        [self initialazeSquares];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(timerMove) userInfo:nil repeats:YES];
    }else{
        [self.countTF setEnabled:YES];
        [self.speedTF setEnabled:YES];
        [self.runButton setTitle:[self.titles objectAtIndex:0] forState: UIControlStateNormal];
        self.work = NO;
        [self.timer invalidate];
    }
}

- (void) initialazeSquares{
    for (NSUInteger i = 1; i < [self.squares count]; i++) {
        if(i > 0){
            [[self.squares objectAtIndex:i] setHidden:YES];
            //need release????
            //[[self.squares objectAtIndex:i] release];
            [self.squares removeObjectAtIndex:i];
            
            i--;
        }
    }
    self.countSquares = [self.countTF.text intValue] == 0 ? 1 : [self.countTF.text intValue];
    
    
    double deltaA = 2 * M_PI / self.countSquares;
    for (int i = 1; i < self.countSquares; i++){
        UIImageView* imageTmp = [[UIImageView alloc] initWithFrame:CGRectMake(cos(self.angle + deltaA * i) * self.radius + self.axis.x - 40,
                                                                              sin(self.angle + deltaA * i) * self.radius + self.axis.y + 100 - 40, 80, 80)];
        UIColor* red = [UIColor redColor];
        [imageTmp setBackgroundColor:red];
//        [self.squares ]
        [self.squares addObject:imageTmp];
        [self.view addSubview:imageTmp];
        
        [imageTmp release];
    }
}

- (void) timerMove{
    //пересчитать скорость
    double deltaA = 2 * 3.1415 * self.speed / 1000;
    self.angle += deltaA;
    double deltaAdditional = 2 * M_PI / self.countSquares;
    for(NSUInteger i = 0; i < self.countSquares; i++){
        CGPoint newPosition = self.image.center;
        newPosition.x = cos(self.angle + deltaAdditional * i) * self.radius + self.axis.x;
        newPosition.y = sin(self.angle + deltaAdditional * i) * self.radius + self.axis.y + 100;
        [[self.squares objectAtIndex:i] setCenter:newPosition];
    }
}


@end
