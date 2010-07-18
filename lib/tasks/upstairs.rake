namespace :up do
  namespace :once do
    namespace :cluster do

      task :create => :environment do
      
        THRESHOLD = 10
        N = 5
        clusterer = Ai4r::Clusterers::KMeans.new
      
      
        Tile.all.each do |tile|
          tile.clusterify!(clusterer, THRESHOLD, N)
        
        
        end
      
      
      end

    end


  end
end