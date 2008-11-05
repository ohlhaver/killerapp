class HaufensController < ApplicationController



def show
  unless read_fragment({:l => @l, :id => params[:id], :page => params[:page] || 1}) 
  fetch_stories nil
  end
end

def filter_haufen_by_opinions
  unless read_fragment({:l => @l, :id => params[:id], :page => params[:page] || 1})
  fetch_stories 1 
  end     
  render :action => 'show'
  
end

protected
def fetch_stories(conditions)   
   @haufen = Haufen.find(params[:id])
    @haufen_stories =[]
    member_array = @haufen.members.split(/\ /)
    member_array.each do |member|
       @haufen_stories += Rawstory.find(member).to_a
    end    

      opinion_stories = @haufen_stories.find_all {|u| u.opinion == 1 }
      @opinion_weight = opinion_stories.size
    @haufen_stories = opinion_stories if conditions != nil
    @haufen_stories = @haufen_stories.sort_by {|u| - u.id } 
    @haufen_stories = @haufen_stories.paginate :page => params[:page],
                                         :per_page => 6
end
   
   
  
end








