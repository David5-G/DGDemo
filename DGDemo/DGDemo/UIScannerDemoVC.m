//
//  UIScannerDemoVC.m
//  DGDemo
//
//  Created by david on 2018/10/17.
//  Copyright © 2018 david. All rights reserved.
//

#import "UIScannerDemoVC.h"

@interface UIScannerDemoVC ()

@end

@implementation UIScannerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"UIScanner";
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    //[self scannerTest];
    [self scannerDemo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)scannerTest {
    
    //1-------------------------
    NSString *str1 = @"x137 sUmall casES xof bananas";
    NSScanner *scanner1 = [NSScanner scannerWithString:str1];
    NSCharacterSet *ignoreSet = [NSCharacterSet characterSetWithCharactersInString:@"x"];//①
    scanner1.charactersToBeSkipped = ignoreSet;
    scanner1.caseSensitive = NO;
    
    //因为①忽略了x,所有这里写"x13是识别不了的,只需要写13"
    NSString *scanStr1 = @"13";
    NSString *container1;
    BOOL success3 = [scanner1 scanString:scanStr1 intoString:&container1];
    NSLog(@"success:%d, container1: **%@**",success3,container1);
    
    //charactersToBeSkipped对scanUpToString不起作用
    NSString *scanStr2 = @"of";
    NSString *container2;
    [scanner1 scanUpToString:scanStr2 intoString:&container2];
    NSLog(@"container2: **%@**",container2);
    
    
    //2----------------------------
    scanner1.scanLocation = 0;
    NSInteger anInteger;
    [scanner1 scanInteger:&anInteger];
    NSLog(@"anInteger: %ld",anInteger);
    
    
    //3.过滤不需要的字符
    NSLog(@"-------- 过滤字符 -------");
    NSString *str2 = @"12xx3texxxst1x2Demxoxltexst";
    NSScanner *scanner2 = [NSScanner scannerWithString:str2];
    NSCharacterSet *scanSet2 = [NSCharacterSet characterSetWithCharactersInString:@"Dtest123mo"];
    scanner2.charactersToBeSkipped = scanSet2;
    
    while (!scanner2.isAtEnd) {
        NSLog(@"scanLocation: %ld", scanner2.scanLocation);
        
        NSString *cStr;
        if ([scanner2 scanUpToCharactersFromSet:scanSet2 intoString:&cStr]) {
            NSLog(@"cStr=%@, %ld",cStr, scanner2.scanLocation);
        }
    }
}


- (void)scannerDemo {
    
    NSString *string = @"Product: Acme Potato Peeler; Cost: 0.98 73\n\
    Product: Chef Pierre Pasta Fork; Cost: 0.75 19\n\
    Product: Chef Pierre Colander; Cost: 1.27 2\n\
    \n";
    
    NSCharacterSet *semicolonSet;
    NSScanner *theScanner;
    
    NSString *PRODUCT = @"Product:";
    NSString *COST = @"Cost:";
    
    NSString *productName;
    float productCost;
    NSInteger productSold;
    
    semicolonSet = [NSCharacterSet characterSetWithCharactersInString:@";"];
    theScanner = [NSScanner scannerWithString:string];
    
    while (!theScanner.isAtEnd) {
        
        if ([theScanner scanString:PRODUCT intoString:NULL] &&
            [theScanner scanUpToCharactersFromSet:semicolonSet intoString:&productName] &&
            [theScanner scanString:@";" intoString:NULL] &&
            [theScanner scanString:COST intoString:NULL] &&
            [theScanner scanFloat:&productCost] &&
            [theScanner scanInteger:&productSold]) {
            
            NSLog(@"(%@: $%.2f)", productName, productCost * productSold);
        }
    }
    
}

@end
