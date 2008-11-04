# Include hook code here

require 'active_support'
require 'must'
require 'must/rule'

Object.__send__ :include, Must
