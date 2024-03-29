#--
# Copyright (c) 2008 Matson Systems, Inc.
# Released under the BSD license found in the file 
# LICENSE included with this ActivityStreams plug-in.
#++
# Template to generate the controllers
class ActivityStreamPreferencesController < ApplicationController
  include ActivityStreamPreferencesModule
  before_filter :require_user, :except => :feed
end
