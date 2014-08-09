module Jekyll
  class CategoryAwareNextGenerator < Generator

    safe true
    priority :high

    def generate(site)
      site.categories.each_pair do |category_name, posts|
        posts.sort! { |a, b| b <=> a }

        posts.each do |post|
          position = posts.index post

          if position && position > 0
            category_prev= posts[position -1]
          else
            category_prev = nil
          end

          post.data["#{category_name}_prev"] = category_prev unless category_prev.nil?
        end
      end
    end
  end
end
