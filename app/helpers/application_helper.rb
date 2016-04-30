module ApplicationHelper
  def able_to_delete?(object)
    current_user && current_user.author_of?(object)
  end
end
