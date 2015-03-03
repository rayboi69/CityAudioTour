//
//  SearchBarDelegate.swift
//  CityAudioTour
//
//  Created by Pichan Vasantakitkumjorn on 3/2/15.
//  Copyright (c) 2015 SE491-591. All rights reserved.
//

import Foundation

class SearchBarDelegate:NSObject,UISearchBarDelegate{
    //Need this constructor to create a super class (NSObject).
    override init(){
        super.init()
    }
    
    //When we click search button on the keyboard, this method will be called to 
    //handle it.
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        //Search attraction based on our database.
    }
    
    
}