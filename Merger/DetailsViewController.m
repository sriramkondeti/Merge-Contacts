//
//  DetailsViewController.m
//  Merger
//
//  Created by Sri Ram on 12/20/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import "DetailsViewController.h"
#import "AppDelegate.h"
@interface DetailsViewController ()
{
    AppDelegate *delegate ;
    NSMutableArray *mergableContactArr;
    NSMutableDictionary *temp;

}
@end

@implementation DetailsViewController
@synthesize detailsTextview;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict =temp = [NSMutableDictionary dictionary];
    mergableContactArr = [NSMutableArray array];
    dict = [delegate.contactArray objectAtIndex:delegate.selectedContact];
    NSArray *keyArray = [dict allKeys];
    for (int i=0; i<keyArray.count ; i++) {
        if (![[keyArray objectAtIndex:i] isEqual:@"PictureThumbnailUrl"] && ![[keyArray objectAtIndex:i] isEqual:@"ID"] ) {
        detailsTextview.text = [NSString stringWithFormat:@"%@%@ : %@\n\n", detailsTextview.text, [keyArray objectAtIndex:i],[dict objectForKey:[keyArray objectAtIndex:i]]];
        }
    }
    for (int i=0; i<delegate.contactArray.count; i++) {
        if (i!=delegate.selectedContact) {
            
            temp = [delegate.contactArray objectAtIndex:i];
            if ([[temp objectForKey:@"Account"] isEqual:[dict objectForKey:@"Account"]] ) {
                [mergableContactArr addObject:temp];
            }
        }
    }
    
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return mergableContactArr.count ;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    temp = [mergableContactArr objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = [temp objectForKey:@"FullName"]?[temp objectForKey:@"FullName"]:[temp objectForKey:@"FirstName"];
    cell.textLabel.text = [temp objectForKey:@"Account"];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {

     NSMutableArray * arr = [[NSMutableArray alloc]init];
     [arr addObject:[delegate.contactArray objectAtIndex:delegate.selectedContact]];
     NSMutableDictionary *dict;
     
     for (int i=1;i<=mergableContactArr.count;i++){
         dict =[[NSMutableDictionary alloc]initWithDictionary: [mergableContactArr objectAtIndex:i-1]];
         for (int j=0;j<[[dict allKeys]count]; j++) {
             
             
             [dict setObject: [dict objectForKey: [[dict allKeys] objectAtIndex:j]] forKey: [NSString stringWithFormat:@"%@%d",[[dict allKeys] objectAtIndex:j],i ]];
             [dict removeObjectForKey: [[dict allKeys] objectAtIndex:j]];
         }
         
         [arr addObject:dict];
     }
     
     NSMutableDictionary *mergeddict  = [[NSMutableDictionary alloc]init];
for (NSDictionary *dictionary in arr)
    
    [ mergeddict setValuesForKeysWithDictionary:dictionary];
     NSLog(@"%@", mergeddict);
     delegate.contactArray=[NSMutableArray arrayWithObjects:mergeddict, nil];
 }
     

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    NSArray *selectedKeyArr = [NSMutableArray array];
    NSArray *selectedValArr = [NSMutableArray array];
    NSArray *mergeKeyArr = [NSMutableArray array];
    NSArray *mergeValArr = [NSMutableArray array];
  
    selectedKeyArr =  [[delegate.contactArray objectAtIndex:delegate.selectedContact] allKeys] ;
    selectedValArr = [[delegate.contactArray objectAtIndex:delegate.selectedContact] allValues];
    
    for (int k=0; k<mergableContactArr.count; k++) {
        
        mergeKeyArr =  [[mergableContactArr objectAtIndex:k] allKeys] ;
        mergeValArr = [[mergableContactArr objectAtIndex:k] allValues];
    
    for (int i=0; i<[selectedKeyArr count]; i++)
    {
        for (int j=0; j<[mergeKeyArr count];j++) {
            
            
            NSLog(@"val :%@, key :%@",[mergeValArr objectAtIndex:j], [mergeKeyArr objectAtIndex:j]);

            if ([[mergeKeyArr objectAtIndex:j] isEqual:@"PictureThumbnailUrl"]) {
                ;
            }
           else  if ([[selectedKeyArr objectAtIndex:i] isEqual:[mergeKeyArr objectAtIndex:j]] && !([[selectedValArr objectAtIndex:i]isEqual:[mergeKeyArr objectAtIndex:j]])) {
                NSMutableDictionary * dict = [delegate.contactArray objectAtIndex:delegate.selectedContact];
             //   [dict setObject:[[NSMutableArray alloc] initWithObjects:[selectedValArr objectAtIndex:i],[mergeValArr objectAtIndex:j]  , nil] forKey:[selectedKeyArr objectAtIndex:i]];
                
                
            }
            else if (!([selectedKeyArr containsObject:[mergeKeyArr objectAtIndex:j]]))
            
            {

                [[delegate.contactArray objectAtIndex:delegate.selectedContact] setValue:[mergeValArr objectAtIndex:j]  forKey:[mergeKeyArr objectAtIndex:j] ];
        }
        
        
    }
    }
    
    

}
    
    NSLog(@"%@",[delegate.contactArray objectAtIndex:delegate.selectedContact]);
}
*/

@end
