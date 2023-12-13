//
//  ViewController.m
//  Tasks-C
//
//  Created by Nikits Panaskin on 27.11.2023.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadItems];

    self.navigationItem.title = @"Todo list";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
}

#pragma mark - Adding items

- (void)addNewItem:(UIBarButtonItem *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add new TODO"
                                                                             message:@"Create a new task"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
           textField.placeholder = @"Enter your text";
           // You can configure the text field further if needed
       }];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        // Handle the OK button action
        UITextField *textField = alertController.textFields.firstObject;
        NSString *enteredText = textField.text;
        NSDictionary *currentItem = @{@"name": enteredText, @"category": @"Private"};
        [self.items addObject:currentItem];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow: self.items.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveItems]; // Save items after adding a new one
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // Handle the CANCEL button action
    }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    // Present the alert controller
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TodoItemRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath: indexPath];
    
    NSDictionary *item = self.items[indexPath.row];
    cell.textLabel.text = item[@"name"];
    
    if ([item[@"completed"] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *item = [self.items[indexPath.row] mutableCopy];
    BOOL completed = [item[@"completed"] boolValue];
    item[@"completed"] = @(!completed);
    
    self.items[indexPath.row] = item;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = ([item[@"completed"] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self saveItems];
};

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
  
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveItems];
    }
}

#pragma mark - Load todos

- (void)loadItems {
    // Load saved items from UserDefaults
    NSArray *savedItems = [[NSUserDefaults standardUserDefaults] objectForKey:@"items"];
    if (savedItems) {
        self.items = [NSMutableArray arrayWithArray:savedItems];
    } else {
        // If no saved items, initialize with default items
        self.items = [@[@{@"name": @"Initial task", @"category": @"Private", @"completed": @NO}]
                         mutableCopy];
    }
}

- (void)saveItems {
    // Save items to UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:self.items forKey:@"items"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
