# Chest
Chest allows you to store objects from anywhere to keep them around, check equality...  
Store an object with `Chest add: anObject` and access it with: `Chest at: anIndex`.
*Pro tip: Click on an object in the list to access it in the playground.*
![image](https://user-images.githubusercontent.com/32486709/59114830-54828000-8948-11e9-83a7-9631990bcb76.png)

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
