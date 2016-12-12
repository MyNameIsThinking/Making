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
                   [UIColor colorWithRed:0xe5/255.f green:0x41/255.f blue:0x75/255.f alpha:1.f],
                   [UIColor colorWithRed:0x00/255.f green:0x00/255.f blue:0x00/255.f alpha:1.f],
                   [UIColor colorWithRed:0xe6/255.f green:0xe6/255.f blue:0xe6/255.f alpha:1.f],
                   [UIColor colorWithRed:0x36/255.f green:0xa5/255.f blue:0xb0/255.f alpha:1.f],
                   [UIColor colorWithRed:0xed/255.f green:0x5b/255.f blue:0x2f/255.f alpha:1.f],
                   [UIColor colorWithRed:0x7b/255.f green:0xb6/255.f blue:0x41/255.f alpha:1.f],
                   [UIColor colorWithRed:0xfc/255.f green:0xb3/255.f blue:0x2c/255.f alpha:1.f],
                   nil];
    }
    
    return _colors;
}
- (NSArray *)fonts {

    if (!_fonts) {
        _fonts = [[NSArray alloc] initWithObjects:
                  @"SanFranciscoDisplay-Bold",
                  @"HelveticaNeue-Light",
                  @"AvenirNextCondensed-Heavy",
                  @"Courier-Bold",
                  @"Georgia-Bold",
                  @"MarkerFelt-Wide",
                  @"TimesNewRomanPS-BoldMT",
                  @"Verdana",
                  nil];
    }
    
    return _fonts;
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
    } else if ([self.currentElement isEqualToString:@"fontSize"]) {
        _model.fontSize = [string integerValue];
    } else if ([self.currentElement isEqualToString:@"fontName"]) {
        _model.fontName = string;
    } else if ([self.currentElement isEqualToString:@"alignment"]) {
        _model.textAlignment = [string integerValue];
    } else if ([self.currentElement isEqualToString:@"mainPosition"]) {
        _model.mainPosition = [string integerValue];
    } else if ([self.currentElement isEqualToString:@"identifier"]) {
        _model.identifier = string;
    } else if ([self.currentElement isEqualToString:@"forewordText"]) {
        _model.forewordText = string;
    } else if ([self.currentElement isEqualToString:@"forewordFontSize"]) {
        _model.forewordFontSize = [string integerValue];
    } else if ([self.currentElement isEqualToString:@"forewordAlignment"]) {
        _model.forewordAlignment = [string integerValue];
    } else if ([self.currentElement isEqualToString:@"forewordPosition"]) {
        _model.forewordPosition = [string integerValue];
    } else if ([self.currentElement isEqualToString:@"forewordFontName"]) {
        _model.forewordFontName = string;
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
