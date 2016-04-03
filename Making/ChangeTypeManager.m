//
//  ChangeTypeManager.m
//  Making
//
//  Created by rico on 2016/4/3.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "ChangeTypeManager.h"

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
    [array addObject:[[XMLUtil alloc] initWithFileName:@"textModel"]];
    [array addObject:[[XMLUtil alloc] initWithFileName:@"textModel"]];
    [array addObject:[[XMLUtil alloc] initWithFileName:@"textModel"]];
    [array addObject:[[XMLUtil alloc] initWithFileName:@"textModel"]];
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
                   nil];
    }
    
    return _colors;
}
@end

@interface XMLUtil () <NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, retain) CoreTextModel *model;

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
    } else if ([self.currentElement isEqualToString:@"fontSize"]) {
        _model.fontSize = [string floatValue];
    } else if ([self.currentElement isEqualToString:@"alignment"]) {
        _model.alignment = [NSNumber numberWithInt:[string intValue]];
    } else if ([self.currentElement isEqualToString:@"frame"]) {
        _model.frame = CGRectFromString(string);
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

    _models = [[NSArray alloc] initWithObjects:_model, nil];
}
@end
