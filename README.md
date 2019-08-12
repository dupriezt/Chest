# Chest
Chest allows you to store objects from anywhere to keep them around, check equality...  
Store an object with `Chest add: anObject` and access it with: `Chest at: anIndex`.  
The rest of the commands can be seen in the help panel.  
![ChestPicture2](https://user-images.githubusercontent.com/32486709/62878741-f9934d80-bd29-11e9-93dd-5969fbf6de72.png)

## Open your Chest
Chest is available in the **debugging menu** of Pharo.
![image](https://user-images.githubusercontent.com/32486709/59115077-cce94100-8948-11e9-85c6-903d459b89ae.png)

## Install Chest
```smalltalk
Metacello new
    baseline: 'Chest';
    repository: 'github://dupriezt/Chest';
    load.
```
*Will load [Spec](https://github.com/pharo-spec/Spec) and [New Tools](https://github.com/pharo-spec/NewTools)*

## More Details
### ID
Each Chest instance has an ID (Integer). These IDs are unique. No two Chest can ever have the same ID (unless of course one re-initialize the Chest class).

### Default Chest
This is an instance of Chest that always exists, always has ID = 1, and can be interacted with in the same way as any other Chest by sending the messages to the Chest class.

### API
```
	Chest class
		#new
			Create and return a new Chest
		#newNamed: aString
			Create and return a new Chest, with the provided name
		#withId: anInteger
			Return the Chest whose ID is @anInteger

	Chest instance
		#add: anObject
			Add anObject to this Chest
		#at: anInteger
			Gets the object stored in this Chest at index @anInteger
		#contents
			Gets an OrderedCollection with the content of this Chest. This collection is a copy so editing it directly does not affect this Chest.
		#empty
			Removes all objects from this Chest
		#name
			Gets the name of this Chest
		#id
			Gets the ID of this Chest
		#remove
			Destroy this Chest (it will no longer appear in the Chest UI)
		#remove: anObject
			Remove @anObject from this Chest
		#removeAt: anInteger
			Remove the object ar index @anInteger from this Chest
```
