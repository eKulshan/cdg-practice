#!/usr/bin/env ruby
# frozen_string_literal: true

def create_pokemon_team
  team = []
  print 'Please enter the size of your team > '
  size = gets.to_i
  1.upto(size) do |i|
    print "Enter #{i} pokemon name and color > "
    name, color = gets.chomp.split(' ')
    team << { name: name, color: color }
  end
  team
end
