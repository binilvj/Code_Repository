# Email Analysis Using Outlook COM Libraries
# Created	:2019-12-17
# Author	:Binil
# Description	:Attempt to use Python to analysis Emails in Outlook
#

import win32com.client as win32
from win32com.client import constants
import pandas as pd

accounts = win32.Dispatch("Outlook.Application").Session.Accounts

### In case of error in next stage, program needed restarted

outlook  = win32.gencache.EnsureDispatch("Outlook.Application")
accounts = outlook.Session.Accounts

print(outlook)
print(outlook.GetNamespace("MAPI"))
print(outlook.Session)

##Outlook accounts

print("Number of account:",account.count)
print([accounts.Item(i).DisplayName for i in list(range(1,accounts.Count)) ])

## Inbox
#
print(outlook.Session.GetDefaultFolder(constants.olFolderInbox))

## Folder count
print(outlook.Session.Folders.Count)

## Exploring folders under an account
## Delivery store is of type "NameSpace"
## inbox.GetRootFolder().Folders returns a collection of folders

print(accounts.Item(1).DeliveryStore.DisplayName) 
mail1=accounts.Item(1).DeliveryStore
print([n.Name for n in list(mail1.GetRootFolder().Folders)])

inbox=mail1.GetRootFolder(constants.olFolderInbox)
print(inbox.Name)
print("Sub folders inside Inbox - ",[n,Name for n in list(inbox.Folders)])


#Starting analysis
#
# selecting 4th folder
dl=inbox.Folders[4]
print("Folder Name - ",dl.Name)
print("Count of items(emails) - ",dl.Items.Count)
print("Folder Path -",dl.FolderPath)
print("Subject of first email - ",dl.Items[1].Subject)
print("Email in a sample conversation:")
print(dl.Items[1].GetConversation().GetTable().GetRowCount())


