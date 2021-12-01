//
//  KKContactsService.m
//  kk_espw
//
//  Created by 阿杜 on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//
#define AbnormalLetter @"#"
#import "KKContactsService.h"
#import "KKContactModel.h"

@implementation KKContactsService

+(void)requestMyContacts:(void (^)(NSArray *, NSArray *))finish
{
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    [para setObject:@"USER_FRIEND_QUERY" forKey:@"service"];
    [para setObject:@"user_protocol" forKey:@"infoCode"];

    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:para model:nil finishCallbackBlock:^(NSString *error, ResModel *resmodel) {
        if (error) {
            [CC_Notice show:error];
            finish(nil,nil);
        }else{
//            NSDictionary *response = resmodel.resultDic[@"response"];
            NSDictionary *response = @{@"userSimpleList" : @[@{@"name":@"adu"},
                                                             @{@"name":@"阿杜"},
                                                             @{@"name":@"赵欢"},
                                                             @{@"name":@"王二"},
                                                             @{@"name":@"王二"},
                                                             @{@"name":@"李二"},
                                                             @{@"name":@"王二"},
                                                             @{@"name":@"长二"},
                                                             @{@"name":@"王张二"},
                                                             @{@"name":@"重二"},
                                                             @{@"name":@"王二"},
                                                             @{@"name":@"^王张二"},
                                                             @{@"name":@"……重二"},
                                                             @{@"name":@"……王二"},
                                                             @{@"name":@"看王张二"},
                                                             @{@"name":@"nm重二"},
                                                             @{@"name":@"86王二"},
                                                             @{@"name":@"了王张二"},
                                                             @{@"name":@"吧重二"},
                                                             @{@"name":@"个人王二"},
                                                             @{@"name":@"已经王张二"},
                                                             @{@"name":@"的重二"},
                                                             @{@"name":@"我二"},
                                               ]};
            NSArray *contactsSource = [KKContactModel mj_objectArrayWithKeyValuesArray:response[@"userSimpleList"]];
            NSArray *contacts = [self sortObjectArray:contactsSource];
            
            NSMutableArray *letterIndexArr = [[NSMutableArray alloc] init];
            for (NSArray <KKContactModel *>*arr in contacts) {
                [letterIndexArr addObject:[arr firstObject].firstLetter];
            }
            finish(contacts,letterIndexArr.mutableCopy);
        }
    }];
}

#pragma mark - 首字母排序
+(NSMutableArray*)sortObjectArray:(NSArray*)objectArray{
 
    NSMutableArray *tempArray = [self ReturnSortObjectArrar:objectArray];
    NSMutableArray *LetterResult = [NSMutableArray array];
    NSMutableArray *sameLetterArr = [NSMutableArray array];
    NSString *tempString;
    //拼音分组
    for (KKContactModel* model in tempArray) {
        if(![tempString isEqualToString:model.firstLetter])
        {
            sameLetterArr = [NSMutableArray array];
            [sameLetterArr  addObject:model];
            [LetterResult addObject:sameLetterArr];
        
            tempString = model.firstLetter;
        }else
        {
            [sameLetterArr  addObject:model];
        }
    }
    return LetterResult;
}

+(NSMutableArray*)ReturnSortObjectArrar:(NSArray*)stringArr{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringArr count];i++){
        KKContactModel *model = stringArr[i];
        NSString *name = model.name?:@"";
        //去除两端空格和回车
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        name = [self RemoveSpecialCharacter:name];
        
        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        NSString *initialStr = [name length]?[name substringToIndex:1]:@"";
        if ([predicate evaluateWithObject:initialStr])
        {
            //首字母大写
            name= [name capitalizedString] ;
        }else{
            if(![name isEqualToString:@""]){
                name = [self getFirstLetter:name];
            }else{
                name = AbnormalLetter;
            }
        }
        model.firstLetter = [name substringToIndex:1];
        [chineseStringsArray addObject:model];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    return chineseStringsArray;
}

//过滤指定字符串   里面的指定字符根据自己的需要添加 过滤特殊字符
+(NSString*)RemoveSpecialCharacter: (NSString *)str {
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound){
        return [self RemoveSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}

//获得词语中每个字的首字母
+ (NSString *)getFirstLetter:(NSString *)chinese{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    if ([pinyin isEqualToString:@""]) {
        return AbnormalLetter;
    }
    //把拼音按字分开
    NSArray *letterArray = [pinyin componentsSeparatedByString:@" "];
    if (!letterArray||letterArray.count==0) {
        return AbnormalLetter;
    }
    NSMutableString *result = @"".mutableCopy;
    for (NSString *letter in letterArray) {
        [result appendString:[letter substringToIndex:1]];
    }
    result = [result uppercaseString].mutableCopy;
    //判断第一个字符是否为字母
    if ([self isCatipalLetter:result]) {
        return result;
    }else{
        return AbnormalLetter;
    }
    return [result uppercaseString];
}

//判断第一个字符是否是大写字母
+ (BOOL)isCatipalLetter:(NSString *)str{
    if ([str characterAtIndex:0] >= 'A' && [str characterAtIndex:0] <= 'Z') {
        return YES;
    }
    return NO;
}


@end
