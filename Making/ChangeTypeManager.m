//
//  ChangeTypeManager.m
//  Making
//
//  Created by rico on 2016/4/3.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "ChangeTypeManager.h"
#import "CoreTextModel.h"

@implementation ChangeTypeManager

static ChangeTypeManager *_instance;
+ (ChangeTypeManager *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ChangeTypeManager alloc] init];
        [_instance startParser];
        [_instance colors];
    });
    
    return _instance;
}
- (void)startParser {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[[XMLUtil alloc] initWithFileName:@"textModel1"]];
    [array addObject:[[XMLUtil alloc] initWithFileName:@"textModel2"]];
    [array addObject:[[XMLUtil alloc] initWithFileName:@"textModel3"]];
    [array addObject:[[XMLUtil alloc] initWithFileName:@"textModel4"]];
    [array addObject:[[XMLUtil alloc] initWithFileName:@"textModel5"]];
    _xmls = [[NSArray alloc] initWithArray:array];
}
- (NSArray *)colors {

    if (!_colors) {
        _colors = [[NSArray alloc] initWithObjects:
                   [UIColor redColor],
                   [UIColor yellowColor],
                   [UIColor blueColor],
                   [UIColor blackColor],
                   [UIColor greenColor],
                   [UIColor whiteColor],
                   nil];
    }
    
    return _colors;
}
@end

@interface XMLUtil () <NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, copy) NSString *currentElement;

@end
@implementation XMLUtil

- (id)initWithFileName:(NSString *)name {
    
    self = [super init];
    if (self) {
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:name ofType:@".xml"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _parser = [[NSXMLParser alloc] initWithData:data];
        _parser.delegate = self;
        [_parser parse];
    }
    
    return self;
}
//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser {}
//准备节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    
    self.currentElement = elementName;
    
    if ([self.currentElement isEqualToString:@"model"]){
        _model = [[CoreTextModel alloc] init];
    }
    
}
//获取节点内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([self.currentElement isEqualToString:@"text"]) {
        _model.text = string;
    } else if ([self.currentElement isEqualToString:@"font"]) {
        _model.font = [UIFont fontWithName:string size:10];
    } else if ([self.currentElement isEqualToString:@"alignment"]) {
        _model.textAlignment = [string integerValue];
    } else if ([self.currentElement isEqualToString:@"frame"]) {
//        _model.frame = CGRectFromString(string);
    } else if ([self.currentElement isEqualToString:@"identifier"]) {
        _model.identifier = string;
    }
}

//解析完一个节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {
    
    if ([elementName isEqualToString:@"model"]) {
    }
    self.currentElement = nil;
}

//解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser {

}
@end
