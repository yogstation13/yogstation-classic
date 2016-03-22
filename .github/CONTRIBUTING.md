# Contributing to Yogstation 13
First off all, let me thank you by choosing to contribute to our GitHub repository. :+1:

Secondly, these are technically rules, but if you feel these are poor guidelines (rules), you're welcome to propose a new ruleset anytime you'd like.

## Updates 2016-03-16

If you are a part of our regular coding team, please create an issue for any new code that you are going to contribute (unless there needs to be secrecy - if so, please contact me about it). We are making this change so that our players have a chance to voice opinions on changes before coders have put too much effort into them. This lets the community have more of a hand in the direction our codebase heads. 

##### Table of Contents
* [Coding Standards](#coding-standards)
* [Getting your Pull Accepted](#getting-your-pull-accepted)

* [Additional Notes](#additional-notes)
    * [Map Merger](#use-the-map-merger)
    * [Text Formatting](#text-formatting)
    * [Credits](#credit)

### Coding Standards

You are expected to follow these specifications in order to make everyone's lives easier, it will also save you and us time, with having to make the changes and us having to tell you what to change. Thank you for reading this section.

* As BYOND's Dream Maker is an object oriented language, code must be object oriented when possible in order to be more flexible when adding content to it. If you are unfamiliar with this concept, it is highly recommended you look it up.

* You must not use colons to override safety checks on an object's variable/function, instead of using proper type casting, unless the code in question is a known resource hog.

* It is rarely allowed to put type paths in a text format, as there are no compile errors if the type path no longer exists. Here is an example:

```
//Good
var/path_type = /obj/item/weapon/baseball_bat

//Bad
var/path_type = "/obj/item/weapon/baseball_bat"
```

* You must use tabs to indent your code, NOT SPACES

* Hacky code, such as adding specific checks, is highly discouraged and only allowed when there is no other option. You can avoid hacky code by using object oriented methodologies, such as overriding a function (called procs in DM) or sectioning code into functions and then overriding them as required.

* Duplicated code is 99% of the time never allowed. Copying code from one place to another maybe suitable for small short time projects but Yogstation focuses on the long term and thus discourages this. Instead you can use object orientation, or simply placing repeated code in a function, to obey this specification easily.

* Code should be modular where possible, if you are working on a new class then it is best if you put it in a new file.

* Bloated code may be necessary to add a certain feature, which means there has to be a judgement over whether the feature is worth having or not. You can help make this decision easier by making sure your code is modular.

* You are expected to help maintain the code that you add, meaning if there is a problem then you are likely to be approached in order to fix any issues, runtimes or bugs.

* Follow the stylesheet. Changing formatting with \red or other tags is not allowed. You must use span classes, which are defined in interface/stylesheet.dm.

* Use the [Map Merger](#use-the-map-merger) whenever you change stuff in maps. Failure to do this will result your PR to be closed.

### Getting your Pull Accepted

1. **You must follow the coding standards**

    Read the [Coding Standards](#coding-standards) above. Hopefully you've read them and followed them before opening your pull request.

2. **Your code must compile**

    This is a given. While your pull request will not be closed over this, it will not be accepted until it does compile cleanly. The Travis bot will check for this automatically, but you should check before you even commit. Warnings should also be cleared.

    Sometimes Travis is a silly bot and something unrelated to your code causes his compile to fail. If this happens you can force a rebuild by closing and reopening your pull request. Alternatively, you can ask a council member to force a rebuild from the Travis page (must be logged in).

    If you change an object's path, you must update any maps that have that item placed on it. Travis checks all maps, including Ministation and Metastation. If Travis is failing you after a path change and you don't know why, check the other maps!

3. **Do not automatically add FILE_DIR.**

    A recurring problem is people adding commits that needlessly spam changes to the DME due to having "Automatically add FILE_DIR" set in their project settings. You'll know if you have this problem if you see this in your commit (as seen through github):
    
    ![FILE_DIR is annoying](https://i.imgur.com/wsWTJmm.png)
    
    Pull Requests that add things to FILE_DIR will be closed. You are free to create a new pull request as soon as you have fixed the issue.
    
   **To fix this problem:**
  
        1.  Open up DreamMaker
        2.  Build > Preferences for tgstation.dme...
        3.  Uncheck "Automatically set FILE_DIR for sub-directories"
        4.  Check compile.
        5.  Close DreamMaker and commit again.
    
4. **Pull requests must be atomic**

    Pull requests must add, remove, or change only ONE feature or related group of features. Do not "bundle" together a bunch of things, as each change may be controversial and hold up everything else. In addition, it's simply neater.

    Bugfix-only PRs are granted some leniency, however not all bugfixes are made equal. It's possible to have a change that technically fixes a bug, but does so in a way that's hacky or otherwise undesirable.

5. **Make explicit commit logs**

  Be clear in exactly what each of your commits do. Esoteric or jokey commit logs are hard for future coders to interpret which makes tracing changes harder. Don't make it too long however since an actual description of your changes goes into your pull request's comment. Ideally the first line should be a short summary, then you have a more fleshed out commentary below that.
  
  Make sure you also add a changelog entry if you're making a big player facing change. The guide to adding changelogs can be found in html/changelog/example.yml.

6. **Clearly state what your pull request does**

  Don't withhold information about your pull request. This will get your pull request delayed, and if it happens too often your pull request will be closed.
  
  Suppose you fixed bug #1234 and changed the name and description of an item as a gag.
  
  ```
  //Bad
  
  In this PR I fixed bug #1234
  
  //Acceptable
  
  In this PR I fixed bug #1234 and also modified the baton's name and description. 
  ```
  
  **If your pull request has new sprites, upload a picture for goddamn sake.**
  
  **Not uploading pictures will slow your pull request down.**

### Additional Notes
  
#### Use the map merger
  
Not doing this will cause the commit to have extremely many line changes in it. In addition, it **will** cause merge conflicts.
 
Here is guide to using the map merging tool:
  
1. Navigate to tools/mapmerge and execute Prepare Maps.bat
 
  This **must** be done **before** changing your stuff.

2. Do your changes and **save**.
  
3. Execute "Run Map Merge.bat" and follow the on-screen instructions.

 When it asks you for which map to merge, you input the **number** that appears before the file path. 
 
 **Not the entire file path!**.
  
 Example:

 `19`

 Ignore anything about `6000 changed tiles` that may appear.
  
4. Commit your changes. You should now see that your map change only has ~50 changed lines instead of 500 000.
  
#### Text Formatting
   
So you're making some code to do something, and you'd like to use a chat-pane text message to inform the players about it. Good for you! Now, there's a few things to know when doing this.

##### Use Span Classes Goddamn

   Span classes allow for **consistent** and informative text formatting.
   
   You may be familiar with span classes if you have previous experience with HTML. There are various types of classes, which can all    be found in interface/stylesheet.dm. Make sure to use the appropriate one for the situation!
   
   `user << "<span class='notice'>You begin welding the vent...</span>"`
   
   This is a notice. Notices show up in simple blue text, and are used for benign informational messages. This notice ends with "...", which implies that the action will take a period of time to complete.
   
   `user << "<span class='warning'>You can't vent crawl while you're stunned!</span>"`
   
   This is a warning! It shows up as simple red text, and are used for things like restriction notifications, machines malfunctioning,
   
   `user.visible_message("<span class='danger'>[user.name] was shocked by the [src.name]!</span>", \`
   
   This is danger! This is heavier red text, used in situations where someone other than yourself is being harmed or having some other potentionally harmful action taken against them, such as cuffing.
   
   `target << "<span class='userdanger'>You are absorbed by the changeling!</span>"`
   
   This is userdanger! Userdanger is used in only one situation: when the person receiving the text message is being directly harmed, such as from attacks or antagonist abilities.
   
#### Credit
   Thanks to-
   /tg/station and their wiki for the guides and the image.

   AsV9 for creating the map merging guide.
