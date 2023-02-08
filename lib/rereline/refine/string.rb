module Rereline
  module Refine
    module String
      refine ::String do
        def grapheme_cluster_slice(*args)
          self.grapheme_clusters.slice(*args).join
        end

        def grapheme_cluster_slice!(*args)
          chars = self.grapheme_clusters
          chars.slice!(*args)
          replace(chars.join)
        end

        def grapheme_cluster_insert(*args)
          chars = self.grapheme_clusters
          chars.insert(*args)
          replace(chars.join)
        end
      end
    end
  end
end
