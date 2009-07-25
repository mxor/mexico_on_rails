module ArticlesHelper
  def levels_collection
    Article.levels.enum_for(:each_with_index).collect { |v, i| [v, i] }
  end
end
