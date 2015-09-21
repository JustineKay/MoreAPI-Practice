
//
//  MusicViewController.m
//  iTunesAPI-Practice
//
//  Created by Justine Gartner on 9/20/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import "MusicViewController.h"
#import "APIManager.h"
#import "iTunesMusicResult.h"

@interface MusicViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *searchResults;


@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchTextField.delegate = self;
}

-(void)makeNewiTunesRequestWithSearchTerm: (NSString *)searchTerm callbackBlock: (void(^)())block{
    
    //searchTerm (comes from our parameter)
    
    //url(media=music, term=searchterm)
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?media=music&term=%@", searchTerm];
    
    //encoded url
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:encodedString];
    
    //make the request
    [APIManager GetRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            
            //do something with data
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"%@", json);
            
            NSArray *results = [json objectForKey:@"results"];
            
            self.searchResults = [[NSMutableArray alloc] init];
            
            for (NSDictionary *result in results) {
                
                NSString *artistName = [result objectForKey:@"artistName"];
                NSString *collectionName = [result objectForKey:@"trackName"];
                
                NSString *thumbnailImageURL = [result objectForKey:@"artworkUrl100"];
                UIImage *thumbnailImage = [APIManager createImageFromString:thumbnailImageURL];
                
                iTunesMusicResult *musicObject = [[iTunesMusicResult alloc] init];
                
                musicObject.artist = artistName;
                musicObject.album = collectionName;
                //musicObject.thumbnailImage = thumbnailImage;
                
                [self.searchResults addObject:musicObject];
                
            }
            
            //NSLog(@"%@", self.searchResults);
            
            //executes the block that we're passing to the method
            block();
        }
    }];
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - tableViewDatasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    iTunesMusicResult *currentResult = self.searchResults[indexPath.row];
    
    cell.textLabel.text = currentResult.artist;
    cell.detailTextLabel.text = currentResult.album;
    cell.imageView.image = currentResult.thumbnailImage;
    
    return cell;
}

#pragma mark - textFieldDelegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //dismiss keyboard
    [self.view endEditing:YES];
    
    //make an api request
    [self makeNewiTunesRequestWithSearchTerm:textField.text callbackBlock:^{
        [self.tableView reloadData];
    }];
    
    
    return YES;
}


@end
