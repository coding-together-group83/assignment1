//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Daniel Koo on 1/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL decimalAlreadyExists;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display;
@synthesize history;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize decimalAlreadyExists;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (! _brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    // append to the history everytime a number is added to the operandStack
    self.history.text = [self.history.text stringByAppendingFormat:@"%@ ", self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.decimalAlreadyExists = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    
    // If the Clear button was pressed, it resets the history label; otherwise
    // the chosen operation will be appended to the history label
    if ([operation isEqualToString:@"C"]) {
        self.history.text = @"";
    } else {
        self.history.text = [self.history.text stringByAppendingFormat:@"%@ ", operation];
    }
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}


- (IBAction)decimalPressed {
    // my way of dealing with the possibility that the "." button will be pressed
    // multiple times when entering a number is to prevent "." from being used
    // more than once per number, which is kept track of by the
    // decimalAlreadyExists property
    if (userIsInTheMiddleOfEnteringANumber) {
        if (!decimalAlreadyExists) {
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    } else {
        self.display.text = @"0.";
        userIsInTheMiddleOfEnteringANumber = YES;
    }
    decimalAlreadyExists = YES;

}






@end
