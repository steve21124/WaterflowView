//
//  ViewController.m
//  WaterFlowDisplay
//
//  Created by B.H. Liu on 12-3-29.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "AsyncImageView.h"
#import <Parse/Parse.h>
#import "FeedObject.h"
#import "JSON.h"
#define NUMBER_OF_COLUMNS 3
#define MAX_LINES 20

@interface ViewController ()
@property (nonatomic,retain) NSMutableArray *imageUrls;
@property (nonatomic,readwrite) int currentPage;
@end

@implementation ViewController
@synthesize imageUrls=_imageUrls;
@synthesize currentPage=_currentPage;
@synthesize queryArray;
@synthesize feedsArray;


#pragma mark helper
- (NSMutableArray*)convertFlickrJsonToArray:(NSString*)json{
    
    NSMutableArray  *photoTitles;         // Titles of images
    NSMutableArray  *photoSmallImageData; // Image data (thumbnail)
    NSMutableArray  *photoURLsLargeImage; // URL to larger image
    
    // Store incoming data into a string
    //NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    // Create a dictionary from the JSON string
    NSDictionary *results = [json JSONValue];
    
    // Build an array from the dictionary for easy access to each entry
    NSMutableArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    /*
    // Loop through each entry in the dictionary...
    for (NSDictionary *photo in photos)
    {
        // Get title of the image
        NSString *title = [photo objectForKey:@"title"];
        
        // Save the title to the photo titles array
        [photoTitles addObject:(title.length > 0 ? title : @"Untitled")];
        
        // Build the URL to where the image is stored (see the Flickr API)
        // In the format http://farmX.static.flickr.com/server/id_secret.jpg
        // Notice the "_s" which requests a "small" image 75 x 75 pixels
        NSString *photoURLString = 
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", 
         [photo objectForKey:@"farm"], [photo objectForKey:@"server"], 
         [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        
        NSLog(@"photoURLString: %@", photoURLString);
        
        // The performance (scrolling) of the table will be much better if we
        // build an array of the image data here, and then add this data as
        // the cell.image value (see cellForRowAtIndexPath:)
        [photoSmallImageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
        
        // Build and save the URL to the large image so we can zoom
        // in on the image if requested
        photoURLString = 
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", 
         [photo objectForKey:@"farm"], [photo objectForKey:@"server"], 
         [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        [photoURLsLargeImage addObject:[NSURL URLWithString:photoURLString]];        
        
        NSLog(@"photoURLsLareImage: %@\n\n", photoURLString); 
    }     
     */
    
    return photos;
}

#pragma mark lifescycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.    
    flowView = [[WaterflowView alloc] initWithFrame:self.view.frame];
    flowView.flowdatasource = self;
    flowView.flowdelegate = self;
    [self.view addSubview:flowView];
    
    self.currentPage = 1;

    /*
    self.imageUrls = [NSMutableArray array];
    self.imageUrls = [NSArray arrayWithObjects:@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://photo.l99.com/bigger/22/1284013907276_zb834a.jpg",@"http://www.webdesign.org/img_articles/7072/BW-kitten.jpg",@"http://www.raiseakitten.com/wp-content/uploads/2012/03/kitten.jpg",@"http://imagecache6.allposters.com/LRG/21/2144/C8BCD00Z.jpg",
@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://img.topit.me/l/201008/11/12815218412635.jpg",                      
                      nil];
    */
    
    NSString* photosJson = @"{\"photos\":{\"page\":1, \"pages\":1981, \"perpage\":250, \"total\":\"495202\", \"photo\":[{\"id\":\"7236302482\", \"owner\":\"44050876@N06\", \"secret\":\"5f7bdcf4d5\", \"server\":\"7092\", \"farm\":8, \"title\":\"o ca\u00e7ador de pipas...\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244518524\", \"owner\":\"33156561@N04\", \"secret\":\"31bce1a2c9\", \"server\":\"5198\", \"farm\":6, \"title\":\"I will survive!\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244336980\", \"owner\":\"7838981@N04\", \"secret\":\"7e5d51c9b9\", \"server\":\"7220\", \"farm\":8, \"title\":\"do bem :)\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244287036\", \"owner\":\"63012314@N00\", \"secret\":\"20df25b4bd\", \"server\":\"7231\", \"farm\":8, \"title\":\"#egg #iphoneonly #instagood #iphone4s #photooftheday\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244165914\", \"owner\":\"72695640@N04\", \"secret\":\"a1e0bcbb3c\", \"server\":\"5462\", \"farm\":6, \"title\":\"DSC07801\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244138470\", \"owner\":\"72695640@N04\", \"secret\":\"358bdd81c7\", \"server\":\"5344\", \"farm\":6, \"title\":\"M\u00e3o\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244142712\", \"owner\":\"72695640@N04\", \"secret\":\"0775fa26e9\", \"server\":\"7083\", \"farm\":8, \"title\":\"DSC07784\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244152326\", \"owner\":\"72695640@N04\", \"secret\":\"77bf3064c0\", \"server\":\"8165\", \"farm\":9, \"title\":\"DSC07787\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244162230\", \"owner\":\"72695640@N04\", \"secret\":\"bc60b393f0\", \"server\":\"5468\", \"farm\":6, \"title\":\"Grande Flor Tropical\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244158998\", \"owner\":\"72695640@N04\", \"secret\":\"8bef6eb3be\", \"server\":\"5445\", \"farm\":6, \"title\":\"Grande Flor Tropical\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244155554\", \"owner\":\"72695640@N04\", \"secret\":\"1e01e5bef5\", \"server\":\"7081\", \"farm\":8, \"title\":\"DSC07828\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244146396\", \"owner\":\"72695640@N04\", \"secret\":\"44b99919f7\", \"server\":\"7244\", \"farm\":8, \"title\":\"Pavilh\u00e3o da Criatividade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244105052\", \"owner\":\"72695640@N04\", \"secret\":\"6e522aa978\", \"server\":\"5312\", \"farm\":6, \"title\":\"DSC07766\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244067288\", \"owner\":\"72695640@N04\", \"secret\":\"8b8659e28c\", \"server\":\"7094\", \"farm\":8, \"title\":\"Panor\u00e2mica Memorial da Am\u00e9rica Latina\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244046262\", \"owner\":\"45442495@N02\", \"secret\":\"467040ddc8\", \"server\":\"5342\", \"farm\":6, \"title\":\"Beautiful Ladies in Masks #beauty #fine #instamood #instalove #photography #photooftheday #imageoftgeday #fashion4ever #portraiture #portraiture #picoftheday #portrait #headshot #masks #brianhaiderstudio\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243994442\", \"owner\":\"81579464@N00\", \"secret\":\"fc1e401dd5\", \"server\":\"7212\", \"farm\":8, \"title\":\"Coexist\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243977502\", \"owner\":\"50786245@N07\", \"secret\":\"14d8b369f1\", \"server\":\"5114\", \"farm\":6, \"title\":\"Plant it...\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243833106\", \"owner\":\"33156561@N04\", \"secret\":\"be7a8f844b\", \"server\":\"7242\", \"farm\":8, \"title\":\"Rosas da princesa\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243797182\", \"owner\":\"8221505@N07\", \"secret\":\"f6c3a4ab16\", \"server\":\"7243\", \"farm\":8, \"title\":\"S\u00f3 faltava ela.\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243688476\", \"owner\":\"39981080@N00\", \"secret\":\"23268b5876\", \"server\":\"7240\", \"farm\":8, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243691146\", \"owner\":\"39981080@N00\", \"secret\":\"f0d51a8063\", \"server\":\"7089\", \"farm\":8, \"title\":\"Queen cover\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243720408\", \"owner\":\"18324667@N00\", \"secret\":\"6c88e212fd\", \"server\":\"5040\", \"farm\":6, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243638832\", \"owner\":\"33353738@N05\", \"secret\":\"85172940d7\", \"server\":\"7098\", \"farm\":8, \"title\":\"ice-cream #sorvete #sp #brasil #melhornacidade @melhornacidade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243661864\", \"owner\":\"11106589@N06\", \"secret\":\"b7275342cb\", \"server\":\"7072\", \"farm\":8, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243522698\", \"owner\":\"28993712@N07\", \"secret\":\"88d9314e75\", \"server\":\"8021\", \"farm\":9, \"title\":\"Marcha da Maconha 2012\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243512074\", \"owner\":\"28993712@N07\", \"secret\":\"c14d60047f\", \"server\":\"7221\", \"farm\":8, \"title\":\"Marcha da Maconha 2012\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243535850\", \"owner\":\"28993712@N07\", \"secret\":\"83263a0718\", \"server\":\"7105\", \"farm\":8, \"title\":\"Marcha da Maconha 2012\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243469312\", \"owner\":\"59969621@N00\", \"secret\":\"d8786aaf33\", \"server\":\"8002\", \"farm\":9, \"title\":\"Come\u00e7ando mais uma semana com dia gostoso! Boa semana biluzada!\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243197576\", \"owner\":\"40622813@N02\", \"secret\":\"a076706cdf\", \"server\":\"7228\", \"farm\":8, \"title\":\"Call Parade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243164802\", \"owner\":\"40622813@N02\", \"secret\":\"1aa0077990\", \"server\":\"8157\", \"farm\":9, \"title\":\"Call Parade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243175464\", \"owner\":\"40622813@N02\", \"secret\":\"d88ac3f185\", \"server\":\"7218\", \"farm\":8, \"title\":\"Call Parade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243181028\", \"owner\":\"40622813@N02\", \"secret\":\"a991d246cd\", \"server\":\"8155\", \"farm\":9, \"title\":\"Call Parade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243166768\", \"owner\":\"40622813@N02\", \"secret\":\"0eb2e86149\", \"server\":\"5159\", \"farm\":6, \"title\":\"Call Parade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243030358\", \"owner\":\"64808665@N06\", \"secret\":\"b26736c0ee\", \"server\":\"7076\", \"farm\":8, \"title\":\"5 2358\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243028706\", \"owner\":\"64808665@N06\", \"secret\":\"fe2f969329\", \"server\":\"8008\", \"farm\":9, \"title\":\"Novo OF na ZL\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7243026992\", \"owner\":\"64808665@N06\", \"secret\":\"33e1ee5794\", \"server\":\"7224\", \"farm\":8, \"title\":\"Mondego da VIP Itaim\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242996248\", \"owner\":\"67710869@N08\", \"secret\":\"1b765ec358\", \"server\":\"7089\", \"farm\":8, \"title\":\"Coffee\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242993006\", \"owner\":\"67710869@N08\", \"secret\":\"5e200b32c4\", \"server\":\"5454\", \"farm\":6, \"title\":\"Cultura\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242987096\", \"owner\":\"50903308@N06\", \"secret\":\"886f1aed76\", \"server\":\"7225\", \"farm\":8, \"title\":\"#Fruit\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242957990\", \"owner\":\"60554590@N02\", \"secret\":\"cbffd421e8\", \"server\":\"7214\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242967714\", \"owner\":\"40622813@N02\", \"secret\":\"abf496be43\", \"server\":\"5339\", \"farm\":6, \"title\":\"Call Parade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242958664\", \"owner\":\"60554590@N02\", \"secret\":\"7a5de9b59e\", \"server\":\"7223\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242972214\", \"owner\":\"40622813@N02\", \"secret\":\"abcbc9980f\", \"server\":\"7090\", \"farm\":8, \"title\":\"Call Parade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242948004\", \"owner\":\"60554590@N02\", \"secret\":\"5fc0e29c03\", \"server\":\"8012\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242954954\", \"owner\":\"60554590@N02\", \"secret\":\"48d89ea173\", \"server\":\"8003\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242953640\", \"owner\":\"60554590@N02\", \"secret\":\"611428667c\", \"server\":\"7230\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242950866\", \"owner\":\"42972826@N03\", \"secret\":\"67a85d6d08\", \"server\":\"7223\", \"farm\":8, \"title\":\"Who shot first?\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242957536\", \"owner\":\"60554590@N02\", \"secret\":\"b18becdf7c\", \"server\":\"7083\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242956184\", \"owner\":\"60554590@N02\", \"secret\":\"08927773b7\", \"server\":\"5323\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242961230\", \"owner\":\"60554590@N02\", \"secret\":\"96fbd5f4be\", \"server\":\"8163\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242947192\", \"owner\":\"60554590@N02\", \"secret\":\"327588ca13\", \"server\":\"7224\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242957706\", \"owner\":\"40622813@N02\", \"secret\":\"f13e6885dd\", \"server\":\"7093\", \"farm\":8, \"title\":\"Call Parade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242950092\", \"owner\":\"60554590@N02\", \"secret\":\"db65b4c9cd\", \"server\":\"5151\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242952310\", \"owner\":\"60554590@N02\", \"secret\":\"52e3a7c477\", \"server\":\"5239\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242951484\", \"owner\":\"60554590@N02\", \"secret\":\"7caa9884bf\", \"server\":\"7102\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242959222\", \"owner\":\"60554590@N02\", \"secret\":\"649297fd8d\", \"server\":\"8019\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242955546\", \"owner\":\"60554590@N02\", \"secret\":\"0087160d5b\", \"server\":\"5072\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242949498\", \"owner\":\"60554590@N02\", \"secret\":\"6d8a012688\", \"server\":\"5326\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242953012\", \"owner\":\"60554590@N02\", \"secret\":\"db6debdb2c\", \"server\":\"8023\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242959792\", \"owner\":\"60554590@N02\", \"secret\":\"f4505c3a93\", \"server\":\"7234\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242948794\", \"owner\":\"60554590@N02\", \"secret\":\"25b00c2d42\", \"server\":\"7087\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242956870\", \"owner\":\"60554590@N02\", \"secret\":\"429d8bf97e\", \"server\":\"7078\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242950794\", \"owner\":\"60554590@N02\", \"secret\":\"c4dc6d2ac9\", \"server\":\"7087\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242960314\", \"owner\":\"60554590@N02\", \"secret\":\"c4d5099c4a\", \"server\":\"7238\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242850470\", \"owner\":\"45101046@N03\", \"secret\":\"51ba6f8f54\", \"server\":\"5325\", \"farm\":6, \"title\":\"Orerion\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242888606\", \"owner\":\"48294276@N03\", \"secret\":\"ebef51ae7a\", \"server\":\"7232\", \"farm\":8, \"title\":\"Yoga\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242869620\", \"owner\":\"64808665@N06\", \"secret\":\"5513916e1c\", \"server\":\"7074\", \"farm\":8, \"title\":\"Mondego indo ao Terminal Bandeira\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242847922\", \"owner\":\"42483572@N00\", \"secret\":\"03fce37f10\", \"server\":\"7094\", \"farm\":8, \"title\":\"P\u00e9rolas de sabedoria.\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242768366\", \"owner\":\"79036768@N07\", \"secret\":\"dc639fa18a\", \"server\":\"7241\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242080754\", \"owner\":\"79036768@N07\", \"secret\":\"1aec092e10\", \"server\":\"7233\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242468642\", \"owner\":\"79036768@N07\", \"secret\":\"58ced106f9\", \"server\":\"7081\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242687708\", \"owner\":\"79036768@N07\", \"secret\":\"e01c963afb\", \"server\":\"7096\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242115418\", \"owner\":\"79036768@N07\", \"secret\":\"c4f80b6cf6\", \"server\":\"8014\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242587826\", \"owner\":\"79036768@N07\", \"secret\":\"10280f5ae9\", \"server\":\"5240\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242476116\", \"owner\":\"79036768@N07\", \"secret\":\"4c81c9f32f\", \"server\":\"7237\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242390420\", \"owner\":\"79036768@N07\", \"secret\":\"1aff9fdd73\", \"server\":\"8147\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242134786\", \"owner\":\"79036768@N07\", \"secret\":\"73027e3472\", \"server\":\"8010\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242155036\", \"owner\":\"79036768@N07\", \"secret\":\"0a2111e498\", \"server\":\"7229\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242367740\", \"owner\":\"79036768@N07\", \"secret\":\"47c74d3ab6\", \"server\":\"8020\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242708320\", \"owner\":\"79036768@N07\", \"secret\":\"d47d3c3cf6\", \"server\":\"7088\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242411706\", \"owner\":\"79036768@N07\", \"secret\":\"97e12ccd5b\", \"server\":\"8017\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242249428\", \"owner\":\"79036768@N07\", \"secret\":\"13f0107f4e\", \"server\":\"5039\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242757780\", \"owner\":\"79036768@N07\", \"secret\":\"0c764feacd\", \"server\":\"8153\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242641992\", \"owner\":\"79036768@N07\", \"secret\":\"1f373312ec\", \"server\":\"7222\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242430876\", \"owner\":\"79036768@N07\", \"secret\":\"f649dd6caa\", \"server\":\"5333\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242259832\", \"owner\":\"79036768@N07\", \"secret\":\"2262802d3c\", \"server\":\"7101\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242504880\", \"owner\":\"79036768@N07\", \"secret\":\"936db4498f\", \"server\":\"7216\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242650696\", \"owner\":\"79036768@N07\", \"secret\":\"ae350ca95d\", \"server\":\"5333\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242484426\", \"owner\":\"79036768@N07\", \"secret\":\"2f45de0ff9\", \"server\":\"7078\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242599250\", \"owner\":\"79036768@N07\", \"secret\":\"b477afe862\", \"server\":\"5119\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242309534\", \"owner\":\"79036768@N07\", \"secret\":\"3d24722b38\", \"server\":\"8010\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242451954\", \"owner\":\"79036768@N07\", \"secret\":\"c1f74e5da1\", \"server\":\"5197\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242677074\", \"owner\":\"79036768@N07\", \"secret\":\"34513092b5\", \"server\":\"8027\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242741904\", \"owner\":\"79036768@N07\", \"secret\":\"7e1b3a229e\", \"server\":\"5325\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242281058\", \"owner\":\"79036768@N07\", \"secret\":\"aed8dd33f0\", \"server\":\"7231\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242720628\", \"owner\":\"79036768@N07\", \"secret\":\"58c0422d50\", \"server\":\"8001\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242576948\", \"owner\":\"79036768@N07\", \"secret\":\"d527a476e3\", \"server\":\"7100\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242291068\", \"owner\":\"79036768@N07\", \"secret\":\"fc9039ff37\", \"server\":\"8002\", \"farm\":9, \"title\":\"IITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242144850\", \"owner\":\"79036768@N07\", \"secret\":\"8a25561912\", \"server\":\"8157\", \"farm\":9, \"title\":\"IITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242068252\", \"owner\":\"79036768@N07\", \"secret\":\"77feeba27a\", \"server\":\"7084\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242219152\", \"owner\":\"79036768@N07\", \"secret\":\"21d032a07d\", \"server\":\"7082\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242356130\", \"owner\":\"79036768@N07\", \"secret\":\"56760ddf86\", \"server\":\"8150\", \"farm\":9, \"title\":\"IITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242733810\", \"owner\":\"79036768@N07\", \"secret\":\"01ab7dd7cb\", \"server\":\"8012\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242459894\", \"owner\":\"79036768@N07\", \"secret\":\"ae33d83d75\", \"server\":\"8013\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242400566\", \"owner\":\"79036768@N07\", \"secret\":\"0555ccc9c7\", \"server\":\"7091\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242565968\", \"owner\":\"79036768@N07\", \"secret\":\"769f9161b8\", \"server\":\"7071\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242101228\", \"owner\":\"79036768@N07\", \"secret\":\"e2d2ee252a\", \"server\":\"5200\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242270034\", \"owner\":\"79036768@N07\", \"secret\":\"1e9385d9e7\", \"server\":\"7236\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242327304\", \"owner\":\"79036768@N07\", \"secret\":\"3e16a732dc\", \"server\":\"7071\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242229862\", \"owner\":\"79036768@N07\", \"secret\":\"5db0f9cb13\", \"server\":\"7233\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242317662\", \"owner\":\"79036768@N07\", \"secret\":\"8557c9fb19\", \"server\":\"7216\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242778350\", \"owner\":\"79036768@N07\", \"secret\":\"b84d61c32a\", \"server\":\"5464\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242555736\", \"owner\":\"79036768@N07\", \"secret\":\"f09b95a53b\", \"server\":\"5328\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242239570\", \"owner\":\"79036768@N07\", \"secret\":\"2a8cdec4a3\", \"server\":\"7215\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242545374\", \"owner\":\"79036768@N07\", \"secret\":\"87852bdc39\", \"server\":\"8013\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242669952\", \"owner\":\"79036768@N07\", \"secret\":\"da4fd9b903\", \"server\":\"7075\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242091770\", \"owner\":\"79036768@N07\", \"secret\":\"8775918d3d\", \"server\":\"8141\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242195404\", \"owner\":\"79036768@N07\", \"secret\":\"8334c4d35e\", \"server\":\"7216\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242300250\", \"owner\":\"79036768@N07\", \"secret\":\"13cd1b1138\", \"server\":\"7211\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242660238\", \"owner\":\"79036768@N07\", \"secret\":\"ef0580d2d0\", \"server\":\"8151\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242494400\", \"owner\":\"79036768@N07\", \"secret\":\"0e7db6e5ac\", \"server\":\"7103\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242380178\", \"owner\":\"79036768@N07\", \"secret\":\"734ecf36e8\", \"server\":\"7220\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242621926\", \"owner\":\"79036768@N07\", \"secret\":\"be2301fd71\", \"server\":\"5333\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242047228\", \"owner\":\"79036768@N07\", \"secret\":\"dbec5b261a\", \"server\":\"8017\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242525914\", \"owner\":\"79036768@N07\", \"secret\":\"6db5a960fb\", \"server\":\"7081\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242631100\", \"owner\":\"79036768@N07\", \"secret\":\"5a8f06e31a\", \"server\":\"7094\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242125314\", \"owner\":\"79036768@N07\", \"secret\":\"3958facc15\", \"server\":\"7223\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242514598\", \"owner\":\"79036768@N07\", \"secret\":\"18d160367d\", \"server\":\"7098\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242058040\", \"owner\":\"79036768@N07\", \"secret\":\"9b32f47079\", \"server\":\"5275\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242186044\", \"owner\":\"79036768@N07\", \"secret\":\"3818a55e5c\", \"server\":\"5326\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242165706\", \"owner\":\"79036768@N07\", \"secret\":\"b49d578cb3\", \"server\":\"8166\", \"farm\":9, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242206896\", \"owner\":\"79036768@N07\", \"secret\":\"d9fa09c346\", \"server\":\"7213\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242611460\", \"owner\":\"79036768@N07\", \"secret\":\"c2927d30c2\", \"server\":\"7211\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242536450\", \"owner\":\"79036768@N07\", \"secret\":\"31c6ac50ec\", \"server\":\"7235\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242421666\", \"owner\":\"79036768@N07\", \"secret\":\"4d1b6034e9\", \"server\":\"7085\", \"farm\":8, \"title\":\"IITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242175576\", \"owner\":\"79036768@N07\", \"secret\":\"21d895fe2d\", \"server\":\"7102\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242337286\", \"owner\":\"79036768@N07\", \"secret\":\"d8ccc19361\", \"server\":\"5116\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242346806\", \"owner\":\"79036768@N07\", \"secret\":\"abb9268232\", \"server\":\"7225\", \"farm\":8, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242698292\", \"owner\":\"79036768@N07\", \"secret\":\"d31e54194b\", \"server\":\"5191\", \"farm\":6, \"title\":\"ITALSUISS\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7234991202\", \"owner\":\"24690815@N03\", \"secret\":\"b0c995706e\", \"server\":\"7092\", \"farm\":8, \"title\":\"Sorrisos\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242604586\", \"owner\":\"48600080825@N01\", \"secret\":\"5806cc996d\", \"server\":\"7087\", \"farm\":8, \"title\":\"Ziper de Ideias\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242589930\", \"owner\":\"10441547@N03\", \"secret\":\"3140873386\", \"server\":\"8016\", \"farm\":9, \"title\":\"Sooner or later, every boy climbs a tree A rite of passage to manhood Maybe to see the world from a higher place Or just because the tree was there Teasing you silly in the hot mid-morning sun\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242514620\", \"owner\":\"59566561@N07\", \"secret\":\"d7ebc221bf\", \"server\":\"7235\", \"farm\":8, \"title\":\"M\u00e1ximus III\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242505590\", \"owner\":\"57610541@N04\", \"secret\":\"31d2e51c89\", \"server\":\"5333\", \"farm\":6, \"title\":\"Salada Istambul @ Restaurante Insalata\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242336634\", \"owner\":\"46202069@N06\", \"secret\":\"c19a5c272c\", \"server\":\"7242\", \"farm\":8, \"title\":\"Step\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242227614\", \"owner\":\"18324667@N00\", \"secret\":\"117dac4646\", \"server\":\"7092\", \"farm\":8, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242131000\", \"owner\":\"73054129@N06\", \"secret\":\"09a349035a\", \"server\":\"5337\", \"farm\":6, \"title\":\"Frodo\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242146976\", \"owner\":\"73054129@N06\", \"secret\":\"b740619fef\", \"server\":\"7077\", \"farm\":8, \"title\":\"Frodo\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242118572\", \"owner\":\"73054129@N06\", \"secret\":\"fdb05f5f25\", \"server\":\"8007\", \"farm\":9, \"title\":\"Frodo\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7242039264\", \"owner\":\"78909679@N08\", \"secret\":\"d295ec0b2f\", \"server\":\"7239\", \"farm\":8, \"title\":\"Showroom Majestik\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241925980\", \"owner\":\"33505330@N05\", \"secret\":\"db13086dd5\", \"server\":\"7214\", \"farm\":8, \"title\":\"cozinha\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241868636\", \"owner\":\"40205611@N04\", \"secret\":\"58a12ce88b\", \"server\":\"7097\", \"farm\":8, \"title\":\"Sono dos justos! #sppb\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241839104\", \"owner\":\"25857962@N08\", \"secret\":\"1a40220df4\", \"server\":\"7225\", \"farm\":8, \"title\":\"Faces | Pop Art | Lobo\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241882444\", \"owner\":\"46202069@N06\", \"secret\":\"dc78cdb711\", \"server\":\"8157\", \"farm\":9, \"title\":\"Recycle #4\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241890358\", \"owner\":\"40205611@N04\", \"secret\":\"643504e50b\", \"server\":\"7073\", \"farm\":8, \"title\":\"#callparade #orelhao #instasampa #saopaulowalk #sampa #saopaulo #streetart\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241835254\", \"owner\":\"46202069@N06\", \"secret\":\"50afb5b720\", \"server\":\"7085\", \"farm\":8, \"title\":\"Recycle 2\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241852710\", \"owner\":\"46202069@N06\", \"secret\":\"72af8097b3\", \"server\":\"7092\", \"farm\":8, \"title\":\"Recycle #3\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241802542\", \"owner\":\"46202069@N06\", \"secret\":\"d10e332db5\", \"server\":\"7074\", \"farm\":8, \"title\":\"Recycle\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241792272\", \"owner\":\"28005877@N05\", \"secret\":\"8fcc1d4ebb\", \"server\":\"8147\", \"farm\":9, \"title\":\"Falei com o TX que eu precisava chegar r\u00e1pido. O bichim veio voando! #thefastandthefurious\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241763684\", \"owner\":\"60554590@N02\", \"secret\":\"ba74331d16\", \"server\":\"7230\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241760288\", \"owner\":\"60554590@N02\", \"secret\":\"e0900597dd\", \"server\":\"5322\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241760968\", \"owner\":\"60554590@N02\", \"secret\":\"fe28a7d320\", \"server\":\"5454\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241765786\", \"owner\":\"60554590@N02\", \"secret\":\"9801e96c99\", \"server\":\"8153\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241762950\", \"owner\":\"60554590@N02\", \"secret\":\"fc93ff23c3\", \"server\":\"7098\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241762346\", \"owner\":\"60554590@N02\", \"secret\":\"4729460f1c\", \"server\":\"7233\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241758962\", \"owner\":\"60554590@N02\", \"secret\":\"e55f081094\", \"server\":\"5461\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241761654\", \"owner\":\"60554590@N02\", \"secret\":\"b327e71c6e\", \"server\":\"8026\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241771922\", \"owner\":\"79016810@N06\", \"secret\":\"1b054a15ce\", \"server\":\"7213\", \"farm\":8, \"title\":\"Ponte Estaiada SP\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241758450\", \"owner\":\"60554590@N02\", \"secret\":\"f61a8830a9\", \"server\":\"5238\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241759674\", \"owner\":\"60554590@N02\", \"secret\":\"6c9d23782c\", \"server\":\"8016\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241757746\", \"owner\":\"60554590@N02\", \"secret\":\"b7239243a9\", \"server\":\"7101\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241767030\", \"owner\":\"60554590@N02\", \"secret\":\"e30eefd14d\", \"server\":\"5194\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241766306\", \"owner\":\"60554590@N02\", \"secret\":\"329667d185\", \"server\":\"7220\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241765194\", \"owner\":\"60554590@N02\", \"secret\":\"585d12a7b1\", \"server\":\"5444\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241764632\", \"owner\":\"60554590@N02\", \"secret\":\"d50a792759\", \"server\":\"7087\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241764186\", \"owner\":\"60554590@N02\", \"secret\":\"cef8179e72\", \"server\":\"7224\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241757100\", \"owner\":\"60554590@N02\", \"secret\":\"c35bf722ae\", \"server\":\"8014\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241614388\", \"owner\":\"67710869@N08\", \"secret\":\"8b1dbc26df\", \"server\":\"8142\", \"farm\":9, \"title\":\"Cultura\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241634456\", \"owner\":\"67710869@N08\", \"secret\":\"7e448d18db\", \"server\":\"7072\", \"farm\":8, \"title\":\"Cultura\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241532126\", \"owner\":\"72809074@N00\", \"secret\":\"9145f1a874\", \"server\":\"7072\", \"farm\":8, \"title\":\"PINHEIRO\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241485076\", \"owner\":\"60554590@N02\", \"secret\":\"9583eb4529\", \"server\":\"7212\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241480442\", \"owner\":\"60554590@N02\", \"secret\":\"cb6d64f454\", \"server\":\"7071\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241486792\", \"owner\":\"60554590@N02\", \"secret\":\"1f9795f6a4\", \"server\":\"7095\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241478638\", \"owner\":\"60554590@N02\", \"secret\":\"59ae56883a\", \"server\":\"7217\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241484382\", \"owner\":\"60554590@N02\", \"secret\":\"706c848a8d\", \"server\":\"7095\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241483634\", \"owner\":\"60554590@N02\", \"secret\":\"014473d662\", \"server\":\"7073\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241485766\", \"owner\":\"60554590@N02\", \"secret\":\"7149294a12\", \"server\":\"7086\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241482464\", \"owner\":\"60554590@N02\", \"secret\":\"c02697cec9\", \"server\":\"8166\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241481044\", \"owner\":\"60554590@N02\", \"secret\":\"a6b309d514\", \"server\":\"8006\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241479780\", \"owner\":\"60554590@N02\", \"secret\":\"5627b0aa6d\", \"server\":\"7239\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241481784\", \"owner\":\"60554590@N02\", \"secret\":\"70c9f6e146\", \"server\":\"5324\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241483066\", \"owner\":\"60554590@N02\", \"secret\":\"43285fd029\", \"server\":\"7212\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241477872\", \"owner\":\"60554590@N02\", \"secret\":\"f7c41d6459\", \"server\":\"7211\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241479242\", \"owner\":\"60554590@N02\", \"secret\":\"2c20e61b21\", \"server\":\"8144\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241341048\", \"owner\":\"14877515@N05\", \"secret\":\"cc71b942c4\", \"server\":\"7095\", \"farm\":8, \"title\":\"Starting the day with superior taste!\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241315938\", \"owner\":\"21933943@N02\", \"secret\":\"c14a287397\", \"server\":\"7212\", \"farm\":8, \"title\":\"Classe\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241297812\", \"owner\":\"60554590@N02\", \"secret\":\"ee73e01869\", \"server\":\"7245\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241291824\", \"owner\":\"60554590@N02\", \"secret\":\"d3766d27d5\", \"server\":\"7243\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241295154\", \"owner\":\"60554590@N02\", \"secret\":\"5bdd24d07f\", \"server\":\"7097\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241291202\", \"owner\":\"60554590@N02\", \"secret\":\"3c937b5ba9\", \"server\":\"7084\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241297394\", \"owner\":\"60554590@N02\", \"secret\":\"fe224f12f4\", \"server\":\"5199\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241294812\", \"owner\":\"60554590@N02\", \"secret\":\"40ae437fd9\", \"server\":\"5036\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241294290\", \"owner\":\"60554590@N02\", \"secret\":\"88672f3b61\", \"server\":\"7103\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241296974\", \"owner\":\"60554590@N02\", \"secret\":\"d3f50a7fea\", \"server\":\"8001\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241295606\", \"owner\":\"60554590@N02\", \"secret\":\"29624dfae5\", \"server\":\"5155\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241296182\", \"owner\":\"60554590@N02\", \"secret\":\"f60c51767c\", \"server\":\"7104\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241293216\", \"owner\":\"60554590@N02\", \"secret\":\"a602b7f342\", \"server\":\"5276\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241292768\", \"owner\":\"60554590@N02\", \"secret\":\"8527646ae5\", \"server\":\"8147\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241296602\", \"owner\":\"60554590@N02\", \"secret\":\"dd8269b730\", \"server\":\"7244\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241293728\", \"owner\":\"60554590@N02\", \"secret\":\"ceeb7d0403\", \"server\":\"7236\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241292354\", \"owner\":\"60554590@N02\", \"secret\":\"8315c5791d\", \"server\":\"5340\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241223158\", \"owner\":\"64623188@N00\", \"secret\":\"7a9b519701\", \"server\":\"5119\", \"farm\":6, \"title\":\"Little phone of horrors\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241183554\", \"owner\":\"28706492@N06\", \"secret\":\"101cde36e5\", \"server\":\"7230\", \"farm\":8, \"title\":\"Olha a\u00ed pessoal ele existe. Os tombos e sustos tamb\u00e9m!! Hahahaha.\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241136934\", \"owner\":\"60554590@N02\", \"secret\":\"5fc1767737\", \"server\":\"5463\", \"farm\":6, \"title\":\"_DSC2944\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241138912\", \"owner\":\"60554590@N02\", \"secret\":\"3612a2e1af\", \"server\":\"7085\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241142716\", \"owner\":\"60554590@N02\", \"secret\":\"9b14487d36\", \"server\":\"7075\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241139940\", \"owner\":\"60554590@N02\", \"secret\":\"d08b717b04\", \"server\":\"7089\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241141130\", \"owner\":\"60554590@N02\", \"secret\":\"6469104f37\", \"server\":\"8159\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241142342\", \"owner\":\"60554590@N02\", \"secret\":\"326672fb48\", \"server\":\"8164\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241141918\", \"owner\":\"60554590@N02\", \"secret\":\"07fab12c18\", \"server\":\"8162\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241138490\", \"owner\":\"60554590@N02\", \"secret\":\"069851f83a\", \"server\":\"8154\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241141520\", \"owner\":\"60554590@N02\", \"secret\":\"b3e3e3efea\", \"server\":\"5469\", \"farm\":6, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241140588\", \"owner\":\"60554590@N02\", \"secret\":\"aa1191c070\", \"server\":\"8016\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241139462\", \"owner\":\"60554590@N02\", \"secret\":\"76c3fbd65b\", \"server\":\"8148\", \"farm\":9, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241137370\", \"owner\":\"60554590@N02\", \"secret\":\"c8ac4075d5\", \"server\":\"7072\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7241137874\", \"owner\":\"60554590@N02\", \"secret\":\"f9e45c4178\", \"server\":\"7087\", \"farm\":8, \"title\":\"11 Carreata da Solidariedade Moema\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7240892272\", \"owner\":\"45984017@N07\", \"secret\":\"a4446356a7\", \"server\":\"8161\", \"farm\":9, \"title\":\"Sao Paulo\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7240855710\", \"owner\":\"44686903@N08\", \"secret\":\"f757ab4abf\", \"server\":\"7097\", \"farm\":8, \"title\":\"#valeapenal\u00eardenovo\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7240796312\", \"owner\":\"24056463@N08\", \"secret\":\"800961d5a2\", \"server\":\"7074\", \"farm\":8, \"title\":\"Psycho-well\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7240544160\", \"owner\":\"43073036@N00\", \"secret\":\"8353513d29\", \"server\":\"7094\", \"farm\":8, \"title\":\"Exagero\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7240549774\", \"owner\":\"10441547@N03\", \"secret\":\"812b30b209\", \"server\":\"8153\", \"farm\":9, \"title\":\"\u201cA cloudy day is no match for a sunny disposition.\u201d ~ William Arthur Ward\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7240399496\", \"owner\":\"50903308@N06\", \"secret\":\"41c3deac2d\", \"server\":\"5326\", \"farm\":6, \"title\":\"#Kingyo #fish on #japanese #luster\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7240327928\", \"owner\":\"11106589@N06\", \"secret\":\"a8b5501c78\", \"server\":\"8027\", \"farm\":9, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7239624240\", \"owner\":\"58055462@N04\", \"secret\":\"a314e58743\", \"server\":\"7245\", \"farm\":8, \"title\":\"SAM_5305\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7222641698\", \"owner\":\"37272035@N07\", \"secret\":\"fbbbddca8c\", \"server\":\"7105\", \"farm\":8, \"title\":\"Aben\u00e7oada e Linda Segunda-Feira aos meus queridos Amigos...***...Blessed and Beautiful Monday to my dear Friends\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7239443936\", \"owner\":\"47462292@N00\", \"secret\":\"5393c0ff74\", \"server\":\"7089\", \"farm\":8, \"title\":\"M\u00fasica de elevador\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7239440406\", \"owner\":\"47462292@N00\", \"secret\":\"75811bb61f\", \"server\":\"5460\", \"farm\":6, \"title\":\"Antony Gormley, S\u00e3o Paulo 2012\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7239138722\", \"owner\":\"26289027@N05\", \"secret\":\"fc6d4dc74e\", \"server\":\"7240\", \"farm\":8, \"title\":\"Zeca Baleiro\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7239138910\", \"owner\":\"26289027@N05\", \"secret\":\"c174acba25\", \"server\":\"5339\", \"farm\":6, \"title\":\"Zeca Baleiro\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7239102128\", \"owner\":\"24061144@N06\", \"secret\":\"e28d3c6792\", \"server\":\"7099\", \"farm\":8, \"title\":\"na protens\u00e3o\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7239095320\", \"owner\":\"24061144@N06\", \"secret\":\"f8595eb79f\", \"server\":\"7220\", \"farm\":8, \"title\":\"infinito\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7239089576\", \"owner\":\"24061144@N06\", \"secret\":\"5995afa0a6\", \"server\":\"7079\", \"farm\":8, \"title\":\"enroladinho\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238954366\", \"owner\":\"42020560@N04\", \"secret\":\"5d7f7075b5\", \"server\":\"8157\", \"farm\":9, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238879446\", \"owner\":\"42020560@N04\", \"secret\":\"102161c96e\", \"server\":\"5450\", \"farm\":6, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238916758\", \"owner\":\"62081504@N05\", \"secret\":\"8495ac30b7\", \"server\":\"7220\", \"farm\":8, \"title\":\"Dna. Parmerinha a nova integrante.\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238840192\", \"owner\":\"55218789@N06\", \"secret\":\"da229f6065\", \"server\":\"5235\", \"farm\":6, \"title\":\"Apresentando ao @rickylopes o Choco Chip\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238808956\", \"owner\":\"72486830@N08\", \"secret\":\"498c3c4b39\", \"server\":\"5031\", \"farm\":6, \"title\":\"MASP Museum - Sight from 9 de Julho Avenue\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238761762\", \"owner\":\"28993712@N07\", \"secret\":\"1fe3fd8c4b\", \"server\":\"7219\", \"farm\":8, \"title\":\"Marcha da Maconha 2012\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238796744\", \"owner\":\"42020560@N04\", \"secret\":\"c819935dc6\", \"server\":\"7085\", \"farm\":8, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238731656\", \"owner\":\"40622813@N02\", \"secret\":\"35201a3bfb\", \"server\":\"7244\", \"farm\":8, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}]}, \"stat\":\"ok\"}";
    
    
    NSString* photosJson2 = @"{\"photos\":{\"page\":1, \"pages\":1981, \"perpage\":250, \"total\":\"495202\", \"photo\":[{\"id\":\"7236302482\", \"owner\":\"44050876@N06\", \"secret\":\"5f7bdcf4d5\", \"server\":\"7092\", \"farm\":8, \"title\":\"o ca\u00e7ador de pipas...\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244518524\", \"owner\":\"33156561@N04\", \"secret\":\"31bce1a2c9\", \"server\":\"5198\", \"farm\":6, \"title\":\"I will survive!\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244336980\", \"owner\":\"7838981@N04\", \"secret\":\"7e5d51c9b9\", \"server\":\"7220\", \"farm\":8, \"title\":\"do bem :)\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244287036\", \"owner\":\"63012314@N00\", \"secret\":\"20df25b4bd\", \"server\":\"7231\", \"farm\":8, \"title\":\"#egg #iphoneonly #instagood #iphone4s #photooftheday\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244165914\", \"owner\":\"72695640@N04\", \"secret\":\"a1e0bcbb3c\", \"server\":\"5462\", \"farm\":6, \"title\":\"DSC07801\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244138470\", \"owner\":\"72695640@N04\", \"secret\":\"358bdd81c7\", \"server\":\"5344\", \"farm\":6, \"title\":\"M\u00e3o\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244142712\", \"owner\":\"72695640@N04\", \"secret\":\"0775fa26e9\", \"server\":\"7083\", \"farm\":8, \"title\":\"DSC07784\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244152326\", \"owner\":\"72695640@N04\", \"secret\":\"77bf3064c0\", \"server\":\"8165\", \"farm\":9, \"title\":\"DSC07787\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244162230\", \"owner\":\"72695640@N04\", \"secret\":\"bc60b393f0\", \"server\":\"5468\", \"farm\":6, \"title\":\"Grande Flor Tropical\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244158998\", \"owner\":\"72695640@N04\", \"secret\":\"8bef6eb3be\", \"server\":\"5445\", \"farm\":6, \"title\":\"Grande Flor Tropical\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244155554\", \"owner\":\"72695640@N04\", \"secret\":\"1e01e5bef5\", \"server\":\"7081\", \"farm\":8, \"title\":\"DSC07828\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244146396\", \"owner\":\"72695640@N04\", \"secret\":\"44b99919f7\", \"server\":\"7244\", \"farm\":8, \"title\":\"Pavilh\u00e3o da Criatividade\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7244105052\", \"owner\":\"72695640@N04\", \"secret\":\"6e522aa978\", \"server\":\"5312\", \"farm\":6, \"title\":\"DSC07766\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0},  {\"id\":\"7238808956\", \"owner\":\"72486830@N08\", \"secret\":\"498c3c4b39\", \"server\":\"5031\", \"farm\":6, \"title\":\"MASP Museum - Sight from 9 de Julho Avenue\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238761762\", \"owner\":\"28993712@N07\", \"secret\":\"1fe3fd8c4b\", \"server\":\"7219\", \"farm\":8, \"title\":\"Marcha da Maconha 2012\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238796744\", \"owner\":\"42020560@N04\", \"secret\":\"c819935dc6\", \"server\":\"7085\", \"farm\":8, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}, {\"id\":\"7238731656\", \"owner\":\"40622813@N02\", \"secret\":\"35201a3bfb\", \"server\":\"7244\", \"farm\":8, \"title\":\"\", \"ispublic\":1, \"isfriend\":0, \"isfamily\":0}]}, \"stat\":\"ok\"}";

    
    NSMutableArray *photos = [self convertFlickrJsonToArray:photosJson2];
    
    
    self.imageUrls = [NSMutableArray array];

                      
    
    // Loop through each entry in the dictionary...
    for (NSDictionary *photo in photos)
    {
        // Get title of the image
        NSString *title = [photo objectForKey:@"title"];
        
        // Save the title to the photo titles array
       // [photoTitles addObject:(title.length > 0 ? title : @"Untitled")];
        
        // Build the URL to where the image is stored (see the Flickr API)
        // In the format http://farmX.static.flickr.com/server/id_secret.jpg
        // Notice the "_s" which requests a "small" image 75 x 75 pixels
        NSString *photoURLString = 
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", 
         [photo objectForKey:@"farm"], [photo objectForKey:@"server"], 
         [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        
        //NSLog(@"photoURLString: %@", photoURLString);
        
        // The performance (scrolling) of the table will be much better if we
        // build an array of the image data here, and then add this data as
        // the cell.image value (see cellForRowAtIndexPath:)
      //  [photoSmallImageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
        
        // Build and save the URL to the large image so we can zoom
        // in on the image if requested
        photoURLString = 
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", 
         [photo objectForKey:@"farm"], [photo objectForKey:@"server"], 
         [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        
        [self.imageUrls addObject:photoURLString];
        
      //  [photoURLsLargeImage addObject:[NSURL URLWithString:photoURLString]];        
        
       // NSLog(@"photoURLsLareImage: %@\n\n", photoURLString); 
    }     

    /*
    //using parse query here
    PFQuery* query = [PFQuery queryWithClassName:@"Route"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:MAX_LINES];
    [queryArray addObject:query];
    [query findObjectsInBackgroundWithBlock:^(NSArray* fetched,NSError* error){
        [queryArray removeObject:query];
        [feedsArray removeAllObjects];
        for (PFObject*obj in fetched){
            FeedObject* feedObject = [[FeedObject alloc]init];
            feedObject.pfobj = obj;
            [feedsArray addObject:feedObject];
            [feedObject release];
        }
        if ([fetched count]<MAX_LINES) {
          //  shouldDisplayNextForFeeds = 0; 
        }else{
          //  shouldDisplayNextForFeeds = 1;  
        }
       // [feedsTable reloadData];
    }];    
    */
    
}


- (void)dealloc
{
    self.imageUrls = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [flowView reloadData];  //safer to do it here, in case it may delay viewDidLoad
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark-
#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterflowView *)flowView
{
    return NUMBER_OF_COLUMNS;
}

- (NSInteger)flowView:(WaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return 8;
}

- (WaterFlowCell *)flowView:(WaterflowView *)flowView_ cellForRowAtIndex:(NSInteger)index
{
        //this method is not called??????
    NSLog(@"cellForRowAtIndex : %d",index);
           
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 1;
		[imageView release];
		imageView.tag = 1001;
	}
    
    float height = [self flowView:nil heightForCellAtIndex:index];
    
    AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / NUMBER_OF_COLUMNS, height);
    
    //what to load here?
    [imageView loadImage:[self.imageUrls objectAtIndex:index]];
	
	return cell;
    
}

- (WaterFlowCell*)flowView:(WaterflowView *)flowView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath : %@",indexPath);
    
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 1;
		[imageView release];
		imageView.tag = 1001;
	}
	
	float height = [self flowView:nil heightForRowAtIndexPath:indexPath];
	
	AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / 3, height);
    
    //check if total image is less than index path, if it is don't load
    if([self.imageUrls count] >= ((indexPath.row + indexPath.section) + (indexPath.section * 4) + 1)){ 
    
        //what to load here
        //(indexPath.row + indexPath.section) + (indexPath.row * 4) using 4 because each vertical column repeat from0 to 4
       [imageView loadImage:[self.imageUrls objectAtIndex:(indexPath.row + indexPath.section) + (indexPath.section * 4)]];
    }else{
        
        
    }
	
	return cell;
    
}





#pragma mark-
#pragma mark- WaterflowDelegate

- (CGFloat)flowView:(WaterflowView *)flowView heightForCellAtIndex:(NSInteger)index
{
    //mod 5 because to divide height to 6 categories height    
    float height = 0;
	switch (index  % 5) {
		case 0:
			height = 127;
			break;
		case 1:
			height = 100;
			break;
		case 2:
			height = 87;
			break;
		case 3:
			height = 114;
			break;
		case 4:
			height = 140;
			break;
		case 5:
			height = 158;
			break;
		default:
			break;
	}
	
	return height;
}

-(CGFloat)flowView:(WaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //mod 5 because to divide height to 6 categories height
	float height = 0;
	switch ((indexPath.row + indexPath.section )  % 5) {
		case 0:
			height = 127;
			break;
		case 1:
			height = 100;
			break;
		case 2:
			height = 87;
			break;
		case 3:
			height = 114;
			break;
		case 4:
			height = 140;
			break;
		case 5:
			height = 158;
			break;
		default:
			break;
	}
	
	height += indexPath.row + indexPath.section;
	
	return height;
    
}

//- (void)flowView:(WaterflowView *)flowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"did select at %@",indexPath);
//}

- (void)flowView:(WaterflowView *)flowView didSelectAtCell:(WaterFlowCell *)cell ForIndex:(int)index
{
    
}

- (void)flowView:(WaterflowView *)_flowView willLoadData:(int)page
{
    [flowView reloadData];
}

@end
