class GroupsController < ApplicationController
  
  before_filter :login_required
      def index

        group_session = (Group.find(:last, :conditions => 'gsession').gsession) 
        @groups = Group.find(:all)
        @groups = @groups.find_all{|z| z.gsession == group_session} 
        @groups = @groups.sort_by {|u| - u.weight } 
        @groups = @groups.first(8)


      end

      def show
        require 'will_paginate'
         @group = Group.find(params[:id])
         @group_stories = @group.rawstories.find(:all, :order => 'rawstories.id DESC')
         @group_stories = @group_stories.paginate :page => params[:page],
                                               :per_page => 8
      end
  
end
