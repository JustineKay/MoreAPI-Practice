//
//  AppsViewController.m
//  iTunesAPI-Practice
//
//  Created by Justine Gartner on 9/20/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import "AppsViewController.h"
#import "iTunesAppResult.h"
#import "APIManager.h"

@interface AppsViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation AppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchTextField.delegate = self;
    
}

-(void)makeNewiTunesRequestWithSearchTerm: (NSString *)searchTerm callbackBlock: (void(^)())block{
    
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?media=software&term=%@", searchTerm];
    
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:encodedString];
    
    [APIManager GetRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *results = [json objectForKey:@"results"];
            
            self.searchResults = [[NSMutableArray alloc] init];
            
            for (NSDictionary *result in results) {
                
                NSString *appName = [result objectForKey:@"trackCensoredName"];
                
                iTunesAppResult *appObject = [[iTunesAppResult alloc] init];
                appObject.name = appName;
                
                [self.searchResults addObject:appObject];
                
            }
            
            block();
        }
    }];
    
}

#pragma mark - tableViewDatasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppsCellIdentifier" forIndexPath:indexPath];
    
    iTunesAppResult *currentResult = self.searchResults[indexPath.row];
    
    cell.textLabel.text = currentResult.name;
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
