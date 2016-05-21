module Authored

  private

  def check_author(object)
    if current_user.author_of?(object)
      yield if block_given?
    else
      controller_name = 'questions' && action_name == 'destroy' ?
      (redirect_to object) : (render head: 403)
    end
  end
end
