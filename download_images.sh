#!/bin/bash

# Create directory if it doesn't exist
mkdir -p /Users/thierryloo/Development/numbersense/assets/grocery

# Download grocery images from Pexels
curl -o /Users/thierryloo/Development/numbersense/assets/grocery/apple.jpg "https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg?auto=compress&cs=tinysrgb&w=300"
curl -o /Users/thierryloo/Development/numbersense/assets/grocery/banana.jpg "https://images.pexels.com/photos/1166648/pexels-photo-1166648.jpeg?auto=compress&cs=tinysrgb&w=300" 
curl -o /Users/thierryloo/Development/numbersense/assets/grocery/bread.jpg "https://images.pexels.com/photos/1775043/pexels-photo-1775043.jpeg?auto=compress&cs=tinysrgb&w=300"
curl -o /Users/thierryloo/Development/numbersense/assets/grocery/milk.jpg "https://images.pexels.com/photos/2580468/pexels-photo-2580468.jpeg?auto=compress&cs=tinysrgb&w=300"
curl -o /Users/thierryloo/Development/numbersense/assets/grocery/cheese.jpg "https://images.pexels.com/photos/4087612/pexels-photo-4087612.jpeg?auto=compress&cs=tinysrgb&w=300"
curl -o /Users/thierryloo/Development/numbersense/assets/grocery/eggs.jpg "https://images.pexels.com/photos/162712/egg-white-food-protein-162712.jpeg?auto=compress&cs=tinysrgb&w=300"
